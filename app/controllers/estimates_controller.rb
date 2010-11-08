class EstimatesController < ProjectsController
  def index
    @estimates = Estimate.all
  end

  def show
    @estimate = Estimate.find(params[:id])

    tasks = @estimate.tasks do
      paginate :page => params[:page], :per_page => params[:rows]
      order_by "#{params[:sidx]} #{params[:sord]}"
    end

    respond_to do |format|
      format.html
      format.json {render :json => tasks.to_jqgrid_json([:number, :name, :note, :billable, :resource_type_id, :quantity, :unit_cost], params[:page], params[:rows], tasks.size)}
    end
  end

  def new
    @project = Estimate.new
  end

  def edit
    @project = Estimate.find(params[:id])
  end

  def create
    @project = Estimate.new(params[:estimate])

    if @project.save
      Activity.create @project.id, "estimate", "created"
      flash[:notice] = "Estimate was successfully created. You'll want to add some tasks to it now."
      redirect_to @project
    else
      render :action => "new"
    end
  end

  def update
    @project = Estimate.find(params[:id])

    if @project.update_attributes(params[:estimate])
      Activity.create @project.id, "estimate", "updated"
      flash[:notice] = 'Estimate was successfully updated.'
      redirect_to @project
    else
      render :action => "edit"
    end
  end

  def destroy
    @estimate = Estimate.find(params[:id])
    Activity.create @estimate.id, "estimate", "deleted?#{@estimate.name}"
    @estimate.destroy

    redirect_to estimates_url
  end

  def convert
    @estimate = Estimate.find params[:id]
    #remove id and type attributes of the estimate (can't be mass-assigned)
    estimate_data = @estimate.attributes
    estimate_data.delete("id")
    estimate_data.delete("type")
    #remove the number of the estimate - the job will get its own one soon
    estimate_data.delete("number")
    #create the new job and give it its data
    @job = Job.new
    @job.attributes = estimate_data
    #the current user becomes the owner of this job
    @job.owner_id = current_user.id
    #set up the relationship between the job and its estimate
    @job.estimate_id = @estimate.id
    #the current user is assigned to this job
    @job.users << current_user
    @estimate.name = "#{@estimate.name} (converted)"
    @estimate.save
    if @job.save
      #calculate the default budget for each task from the total estimate's budget
      if @estimate.tasks.size > 0
        total_quantity = 0
        @estimate.tasks.each do |task|
          total_quantity += task.quantity
        end
      end
      #assign the tasks to the job, and set their budget and users
      @job.tasks = @estimate.tasks
      @estimate.tasks.each do |task|
        task.project = @job
        task.users.clear
        task.users << current_user
        task.budget = ((task.quantity.to_f / total_quantity) * @estimate.budget).floor.to_i
        task.save
      end
      @estimate.delete
      Activity.create @job.id, "job", "Converted estimate '#{@estimate.name.capitalize}' to"
      flash[:notice] = "The estimate has been successfully converted to a job (and has kept its tasks). The budget of each task has been intelligently guessed based on the quantities that you selected in your estimate and the estimate's total budget; you may want to alter these. You have also been set as the owner of the job (lucky you)."
      redirect_to @job
    else
      flash[:alert] = 'The estimate could not be converted :('
      redirect_to estimates_path
    end
  end
end