class ClientsController < ApplicationController
  before_filter :protect_project_manager, :except => [:index, :show]

  def index
    @clients = Client.all
  end

  def show
    @client = Client.find(params[:id])
  end

  def new
    @client = Client.new
  end

  def edit
    @client = Client.find(params[:id])
  end

  def create
    @client = Client.new(params[:client])

    if @client.save
      Activity.create @client.id, "client", "created"
      flash[:notice] = "#{@client.name} was successfully created."
      redirect_to clients_url
    else
      render :action => "new"
    end
  end

  def update
    @client = Client.find(params[:id])

    if @client.update_attributes(params[:client])
      Activity.create @client.id, "client", "updated"
      flash[:notice] = "#{@client.name} was successfully updated."
      redirect_to clients_path
    else
      render :action => "edit"
    end
  end

  def destroy
    @client = Client.find(params[:id])

    begin
      @client.destroy
    rescue ActiveRecord::InvalidForeignKey
      flash[:alert] = "You can't delete #{@client.name} because they still have estimates and jobs. You will need to remove these first."
    else
      Activity.create @client.id, "client", "deleted?#{@client.name}"
    end

    redirect_to clients_url
  end
end