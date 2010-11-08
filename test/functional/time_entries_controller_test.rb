require 'test_helper'

class TimeEntriesControllerTest < ActionController::TestCase
  setup do
    @time_entry = TimeEntry.first
  end

  test "create a time entry" do
    time_entry = TimeEntry.new :user_id => 1, :task_id => Task.first.id, :time_spent_hours => 3, :time_spent_minutes => 42, :extra_time_hours => 2, :extra_time_minutes => 31, :note => "a test time entry"
    assert_difference('TimeEntry.count') do
      assert time_entry.save
    end
    time_entry = TimeEntry.last
    assert_equal time_entry.user_id, 1
    assert_equal time_entry.user, User.find(1)
    assert_equal time_entry.user.name, User.find(1).name
    assert_equal time_entry.task_id, Task.first.id
    assert_equal time_entry.task, Task.first
    assert_equal time_entry.task.name, Task.first.name
    assert_equal time_entry.time_spent, 222
    assert_equal time_entry.extra_time, 151
    assert_equal time_entry.note, "a test time entry"
  end

  test "should get new" do
    get :new
    assert_response :redirect
  end

  test "should create time_entry" do
    assert_difference('TimeEntry.count', 0) do
      assert_difference('TimeEntry.count', 0) do
        post :create, :time_entry => {:user_id => 1, :task_id => 1, :time_spent_hours => "1", :time_spent_minutes => "54"}
      end
    end
  end

  test "should destroy time_entry" do
    time_entry = TimeEntry.find(@time_entry.to_param)
    assert_difference('TimeEntry.count', -1) do
      time_entry.destroy
    end
  end
end