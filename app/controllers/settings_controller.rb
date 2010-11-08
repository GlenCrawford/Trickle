class SettingsController < ApplicationController
  before_filter :protect_administrator

  def protect_administrator
    if not current_user.has_admin_rights
      flash[:alert] = "You must be an administrator to do that."
      redirect_to root_path
    end
  end

  def edit
    @settings = Settings.get
  end

  def update
    @settings = Settings.get

    if @settings.update_attributes(params[:settings])
      Activity.create @settings.id, "settings", "updated"
      flash[:notice] = 'Your settings were successfully updated.'
      redirect_to root_path
    else
      render :action => "edit"
    end
  end
end