require 'test_helper'

class ClientsControllerTest < ActionController::TestCase
  def setup
    sign_in User.first
    @client = Client.first
  end

  # Client activity tests
  test "create client test activity created" do
    @client = Client.new :name => "FDK Inc", :code => "DFK"
    assert_difference('Client.count') do
      assert_difference('Activity.count') do
        post :create, :client => @client.attributes
      end
    end

    @activity = Activity.find(:first, :order => "id DESC")
    @client = Client.find_by_code("IBM")
    assert_not_nil @activity
    assert_not_nil @client
    assert_equal @activity.thing_id, 10
    assert_equal @activity.thing_type, "client"
    assert_equal @activity.action, "created"
  end

  test "edit client test activity created" do
    @client = Client.new :name => "AMD, Inc", :code => "AMD"
    @client.save
    @client = Client.find_by_code("AMD")
    assert_not_nil @client
    assert_difference('Activity.count') do
      put :update, :id => @client.to_param, :client => @client.attributes
    end

    @activity = Activity.find(:first, :order => "id DESC")
    assert_not_nil @activity
    assert @activity.thing_id == @client.id
    assert @activity.thing_type == "client"
    assert @activity.action == "updated"
  end

  test "delete client test activity created" do
    @client = Client.new :name => "Intel Inc", :code => "INL"
    assert @client.save
    @client = Client.find_by_code("INL")
    assert_not_nil @client
    assert_difference('Client.count', -1) do
      assert_difference('Activity.count') do
        delete :destroy, :id => @client.to_param
      end
    end

    @activity = Activity.find(:first, :order => "id DESC")
    assert_not_nil @activity
    assert @activity.thing_id == @client.id
    assert @activity.thing_type == "client"
    assert @activity.action.include? "deleted?"
  end

  test "should get edit" do
    get :edit, :id => @client.to_param
    assert_response :success
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:clients)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should show client" do
    get :show, :id => @client.to_param
    assert_response :success
  end

  test "should create client" do
    @client = Client.new :name => "Christchurch Polytechnic Institute of Technology", :code => "CPIT"
    assert_difference('Client.count') do
      post :create, :client => @client.attributes
    end

    assert_redirected_to clients_path
  end

  test "zshould destroy client" do
    @client = Client.first
    assert_difference('Client.count', -1) do
      delete :destroy, :id => @client.to_param
    end

    assert_redirected_to clients_path
  end

  test "should update client" do
    put :update, :id => @client.to_param, :client => @client.attributes
    assert_redirected_to clients_path
  end
end