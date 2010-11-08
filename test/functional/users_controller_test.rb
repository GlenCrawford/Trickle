require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    sign_in User.first
  end

  # User activity tests
  test "create user test activity created" do
    assert_difference('User.count') do
      assert_difference('Activity.count') do
        post :create, :user => {:first_name => "Mike", :last_name => "Lance", :nick_name => "mikee", :email => "mike@lance.co.nz", :telephone_number => "123456789", :mobile_number => "987654321", :avatar => "lol.jpg", :username => "mikelance", :password => "12345678", :role_id => 4 }
      end
    end

    @activity = Activity.find(:first, :order => "id DESC")
    @user = User.find_by_username("mikelance")
    assert_not_nil @activity
    assert_not_nil @user
    assert @activity.thing_id == @user.id
    assert @activity.thing_type == "user"
    assert @activity.action == "created"
  end

  test "edit user test activity created" do
    @user = User.first
    assert_not_nil @user
    @user[:password] = "12345678"
    assert_difference('Activity.count') do
      put :update, :id => @user.to_param, :user => @user.attributes
    end

    @activity = Activity.find(:first, :order => "id DESC")
    assert_not_nil @activity
    assert @activity.thing_id == @user.id
    assert @activity.thing_type == "user"
    assert @activity.action == "updated"
  end

  test "delete user test activity created" do
    @user = User.new :first_name => "Mike", :last_name => "Lance", :nick_name => "mikeey", :email => "mikey@lance.co.nz", :telephone_number => "1234567789", :mobile_number => "9878654321", :avatar => "lol.jpg", :username => "mikeyy", :password => "12345678", :role_id => 4
    assert @user.save
    @user = User.find_by_username("mikeyy")
    assert_not_nil @user
    assert_difference('User.count', -1) do
      assert_difference('Activity.count') do
        delete :destroy, :id => @user.to_param
      end
    end

    @activity = Activity.find(:first, :order => "id DESC")
    assert_not_nil @activity
    assert @activity.thing_id == @user.id
    assert @activity.thing_type == "user"
    assert @activity.action.include? "deleted?"
  end

  test "create user" do
    assert_difference("User.count") do
      post :create, :user => { :first_name => "Mike", :last_name => "Lance", :nick_name => "mikeyy", :email => "mikee@lance.com", :username => "mmike", :password => "12345678", :role_id => 2, :avatar => "test.bmp", :mobile_number => "029558324", :telephone_number => "029482209" }
    end
  end

  test "cant create user signed out" do
    sign_out User.first
    get :new
    assert_redirected_to new_user_session_path
  end

  test "should get edit" do
    @user = User.first
    get :edit, :id => @user.to_param
    assert_response :success
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should show user" do
    @user = User.first
    get :show, :id => @user.to_param
    assert_response :success
  end

  test "should update user" do
    @user = User.first
    put :update, :id => @user.to_param, :user => @user.attributes
    assert_response :success
  end

  test "aget users" do
    users = User.all
    assert_equal users.size, 5
  end

  test "should destroy user" do
    @user = User.first
    assert_difference('User.count', -1) do
      delete :destroy, :id => @user.to_param
    end

    assert_redirected_to users_path
  end
end