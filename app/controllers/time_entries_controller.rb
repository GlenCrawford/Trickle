class TimeEntriesController < ApplicationController
  def new
    @time_entry = TimeEntry.new
    @jobs = Job.all
  end

  def get_tasks_from_job
    @job = Job.find params[:job_id]
    @tasks = @job.tasks

    respond_to do |format|
      format.json {render :partial => "show.json"}
    end
  end

  def create
    params[:time_entry][:user_id] = current_user.id
    params[:time_entry].delete("need_extra_time")

    @time_entry = TimeEntry.new(params[:time_entry])

    if @time_entry.save
      Activity.create @time_entry.id, "time_entry", "created"
      flash[:notice] = 'Your time entry was successfully added to that task.'
    else
      flash[:alert] = 'Your time entry was not saved, please try again (and do it properly this time).'
    end
    redirect_to jobs_path
  end
end