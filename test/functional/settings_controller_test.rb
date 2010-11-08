require 'test_helper'

class SettingsControllerTest < ActionController::TestCase
  setup do
    @settings = Settings.get
    sign_in User.first
  end

  test "should get edit" do
    get :edit
    assert_response :success
  end

  test "should update settings" do
    put :update, :id => @settings.to_param, :settings => @settings.attributes
    assert_redirected_to root_path
  end

  test "edit settings test activity created" do
    assert_not_nil @settings
    assert_difference('Activity.count') do
      put :update, :id => @settings.to_param, :settings => @settings.attributes
    end

    @activity = Activity.find(:first, :order => "id DESC")
    assert_not_nil @activity
    assert @activity.thing_id == @settings.id
    assert @activity.thing_type == "settings"
    assert @activity.action == "updated"
  end
end