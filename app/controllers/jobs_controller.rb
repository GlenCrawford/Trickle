class JobsController < ProjectsController
  def index
    @jobs = Job.all
  end

  def show
    @job = Job.find(params[:id])

    tasks = @job.tasks do
      paginate :page => params[:page], :per_page => params[:rows]
      order_by "#{params[:sidx]} #{params[:sord]}"
    end

    respond_to do |format|
      format.html
      format.json {render :json => tasks.to_jqgrid_json([:number, :name, :note, :billable, :budget, :status, :user], params[:page], params[:rows], tasks.size)}
    end
  end

  def new
    @project = Job.new
  end

  def edit
    @project = Job.find(params[:id])
  end

  def create
    params[:job][:user_ids] ||= []
    @project = Job.new(params[:job])

    if @project.save
      Activity.create @project.id, "job", "created"
      flash[:notice] = "Job was successfully created. You'll want to add some tasks to it now."
      redirect_to @project
    else
      render :action => "new"
    end
  end

  def update
    @project = Job.find(params[:id])

    params[:job][:user_ids] ||= []
    if @project.update_attributes(params[:job])
      Activity.create @project.id, "job", "updated"
      flash[:notice] = 'Job was successfully updated.'
      redirect_to @project
    else
      render :action => "edit"
    end
  end

  def destroy
    @job = Job.find(params[:id])
    Activity.create @job.id, "job", "deleted?#{@job.name}"
    @job.destroy

    redirect_to jobs_url
  end
end