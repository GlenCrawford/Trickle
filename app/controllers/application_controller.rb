class ApplicationController < ActionController::Base
  protect_from_forgery :except => [:post_tasks]
  before_filter :authenticate_user!
  before_filter :set_current_user

  def protect_team_leader
    if not current_user.has_team_leader_rights
      flash[:alert] = "You must be a team leader to do that."
      redirect_to :action => "index"
    end
  end

  def protect_project_manager
    if not current_user.has_project_manager_rights
      flash[:alert] = "You must be a project manager to do that."
      redirect_to :action => "index"
    end
  end

  def protect_administrator
    if not current_user.has_admin_rights
      flash[:alert] = "You must be an administrator to do that."
      redirect_to :action => "index"
    end
  end

  private

  def set_current_user
    # Get the current user object so it is accessible to models via User.current. Use thread-safe method to do this.
    Thread.current[:user] = current_user
  end
end