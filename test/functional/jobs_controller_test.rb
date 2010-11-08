require 'test_helper'

class JobsControllerTest < ActionController::TestCase
  def setup
    @glen = User.find_by_first_name("Glen")
    sign_in @glen
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:jobs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "ashould create job" do
    assert_difference('Project.count') do
      assert_difference('Job.count') do
        post :create, :job => {:name => "A new job", :budget => 492, :client_id => Client.first.id, :owner_id => @glen.id, :user_ids => [@glen.id]}
      end
    end

    assert_response :redirect
  end

  test "should get edit" do
    get :edit, :id => Job.last.id
    assert_response :success
  end

  test "should update job" do
    put :update, :id => Job.last.id, :job => Job.first.attributes
    assert_response :success
  end

  test "zshould destroy job" do
    assert_difference('Project.count', -1) do
      assert_difference('Job.count', -1) do
        delete :destroy, :id => Job.last.id
      end
    end

    assert_redirected_to jobs_path
  end
end