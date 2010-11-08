class UsersController < ApplicationController
  before_filter :protect_team_leader, :except => [:index, :show, :edit, :update]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
    if current_user.id != @user.id && !current_user.has_team_leader_rights
      flash[:alert] = "You must be a team leader to do that."
      redirect_to :action => "index"
    end
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      Activity.create @user.id, "user", "created"
      flash[:notice] = "#{@user.name} was successfully created."
      redirect_to @user
    else
      @user.password = nil
      render :action => "new"
    end
  end

  def update
    @user = User.find(params[:id])

    if current_user.id != @user.id && !current_user.has_team_leader_rights
      flash[:alert] = "You must be a team leader to do that."
      redirect_to :action => "index"
    end

    if @user.update_attributes(params[:user])
      Activity.create @user.id, "user", "updated"
      flash[:notice] = "#{@user.name} was successfully updated."
      redirect_to @user
    else
      @user.password = nil
      render :action => "edit"
    end
  end

  def destroy
    @user = User.find(params[:id])

    # Try and delete a user. If we get any foreign key errors, then the user will need to fix up any 
    # outstanding tasks/estimates/jobs before the user can be destroyed.
    # Can't have items still assigned to a user that has left the company, can we?
    begin
      @user.destroy
    rescue ActiveRecord::InvalidForeignKey
      flash[:alert] = "You cannot delete this user as they still have estimates, jobs and/or items assigned to them. You will need to fix this up before you can delete #{@user.first_name}."
    else
      # Log an activity if the destroy was successful
      Activity.create @user.id, "user", "deleted?#{@user.name}"
    end

    redirect_to users_url
  end
end