require 'test_helper'

class EstimatesControllerTest < ActionController::TestCase
  setup do
    sign_in User.first
    @estimate = Estimate.first
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create estimate" do
    assert_difference('Estimate.count') do
      post :create, :estimate => @estimate.attributes
    end

    assert_redirected_to estimate_path(assigns(:project))
  end

  test "should get edit" do
    get :edit, :id => @estimate.to_param
    assert_response :success
  end

  test "should update estimate" do
    put :update, :id => @estimate.to_param, :estimate => @estimate.attributes
    assert_redirected_to estimate_path(assigns(:estimate))
  end

  test "should destroy estimate" do
    assert_difference('Estimate.count', -1) do
      delete :destroy, :id => @estimate.to_param
    end

    assert_redirected_to estimates_path
  end

  test "create estimate test activity created" do
    @estimate = Estimate.new :client_id => Client.first.id, :name => "Test", :number => "2", :budget => 45, :creator_id => 1, :created_at => Time.now, :updater_id => 1, :updated_at => Time.now, :status => "open", :estimate_id => Estimate.find_by_name("SEO for Sony").id, :owner_id => 1
    assert_difference('Estimate.count') do
      assert_difference('Activity.count') do
        post :create, :estimate => @estimate.attributes
      end
    end

    @activity = Activity.find(:first, :order => "id DESC")
    @estimate = Estimate.find_by_name("Test")
    assert_not_nil @estimate
    assert_not_nil @activity
    assert_equal @activity.thing_id, 6
    assert @activity.thing_type == "estimate"
    assert @activity.action == "created"
  end

  test "edit estimate test activity created" do
    @estimate = Estimate.new :client_id => Client.first.id, :name => "Test", :number => "2", :budget => 45, :creator_id => 1, :created_at => Time.now, :updater_id => 1, :updated_at => Time.now, :status => "open", :estimate_id => Estimate.find_by_name("SEO for Sony").id, :owner_id => 1
    @estimate.save
    @estimate = Estimate.find_by_name("Test")
    assert_not_nil @estimate
    assert_difference('Activity.count') do
      put :update, :id => @estimate.to_param, :estimate => @estimate.attributes
    end

    @activity = Activity.find(:first, :order => "id DESC")
    assert_not_nil @activity
    assert @activity.thing_id == @estimate.id
    assert @activity.thing_type == "estimate"
    assert @activity.action == "updated"
  end

  test "delete estimate test activity created" do
    @estimate = Estimate.new :client_id => Client.first.id, :name => "Test", :number => "2", :budget => 45, :creator_id => 1, :created_at => Time.now, :updater_id => 1, :updated_at => Time.now, :status => "open", :estimate_id => Estimate.find_by_name("SEO for Sony").id, :owner_id => 1
    assert @estimate.save
    @estimate = Estimate.find_by_name("Test")
    assert_not_nil @estimate
    assert_difference('Estimate.count', -1) do
      assert_difference('Activity.count') do
        delete :destroy, :id => @estimate.to_param
      end
    end

    @activity = Activity.find(:first, :order => "id DESC")
    assert_not_nil @activity
    assert @activity.thing_id == @estimate.id
    assert @activity.thing_type == "estimate"
    assert @activity.action.include? "deleted?"
  end
end
