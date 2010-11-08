require 'test_helper'

class ActivityTest < ActiveSupport::TestCase
  test "create new activity directly" do
    new_activity = Activity.new :user_id => 1, :thing_id => 1, :thing_type => "estimate", :action => "deleted", :action_date => Time.now
    assert new_activity.save
  end

  test "can't create activity without user" do
    new_activity = Activity.new :thing_id => 1, :thing_type => "estimate", :action => "deleted", :action_date => Time.now
    assert !new_activity.save
  end

  test "can't create activity without thing id" do
    new_activity = Activity.new :user_id => 1, :thing_type => "estimate", :action => "deleted", :action_date => Time.now
    assert !new_activity.save
  end

  test "can't create activity without thing type" do
    new_activity = Activity.new :user_id => 1, :thing_id => 1, :action => "deleted", :action_date => Time.now
    assert !new_activity.save
  end

  test "can't create activity without action" do
    new_activity = Activity.new :user_id => 1, :thing_id => 1, :thing_type => "estimate", :action_date => Time.now
    assert !new_activity.save
  end

  test "can't create activity without action date" do
    new_activity = Activity.new :user_id => 1, :thing_id => 1, :thing_type => "estimate", :action => "deleted"
    assert !new_activity.save
  end

  test "get new activity and check attributes" do
    activity = Activity.last

    assert_not_nil activity.user
    assert activity.user.id == 1
    assert activity.thing_id == 1
    assert activity.thing_type == "estimate"
    assert activity.action == "deleted"
    assert_not_nil activity.action_date
  end
end