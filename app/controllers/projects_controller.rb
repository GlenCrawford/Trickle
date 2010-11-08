class ProjectsController < ApplicationController
  before_filter :protect_project_manager, :except => [:index, :show, :post_tasks]

  def post_tasks
    if params[:oper] == "del"
      @task = Task.find(params[:id])
      @project = @task.project
      @task.destroy
      @project.order_tasks
    else
      @project = Project.find params[:project_id]
      if @project.class.name == "Estimate"
        task_params = {:name => params[:name], :note => params[:note], :billable => params[:billable], :resource_type_id => params[:resource_type_id], :quantity => params[:quantity], :unit_cost => params[:unit_cost], :project_id => params[:project_id]}
      elsif @project.class.name == "Job"
        task_params = {:name => params[:name], :note => params[:note], :billable => params[:billable], :budget => params[:budget], :status => params[:status], :user_ids => [params[:user]], :project_id => params[:project_id]}
      end
      if params[:id] == "_empty"
        Task.create task_params
      else
        Task.find(params[:id]).update_attributes(task_params)
      end
    end
    render :nothing => true
  end
end