require 'test_helper'

class TimeEntryTest < ActiveSupport::TestCase
  def setup
    @user_id = 1
    @task = Task.last
  end

  test "count tasks" do
    assert_equal Task.all.size, 23
  end

  test "create time entry" do
    time_entry = TimeEntry.new :user_id => @user_id, :task_id => @task.id, :time_spent_hours => 3, :time_spent_minutes => 42, :extra_time_hours => 2, :extra_time_minutes => 31, :note => "a test time entry"
    assert_difference('TimeEntry.count') do
      assert time_entry.save
    end
  end

  test "get that time entry" do
    time_entry = TimeEntry.last

    assert_equal time_entry.user_id, 1
    assert_equal time_entry.user.name, User.find(1).name
    assert_equal time_entry.task_id, Task.last.id
    assert_equal time_entry.task, Task.last
    assert_equal time_entry.time_spent, 222
    assert_equal time_entry.note, "a test time entry"
    assert_equal time_entry.extra_time, 151
  end

  test "hcreate time entry, check activity created" do
    time_entry = TimeEntry.new :user_id => 2, :task_id => 5, :time_spent_hours => 7, :time_spent_minutes => 6
    assert_difference('TimeEntry.count') do
      assert time_entry.save
    end

    activity = Activity.last
    assert_not_nil activity
  end

  test "can't create time entry without user" do
    time_entry = TimeEntry.new :task_id => @task.id, :time_spent_hours => 3, :time_spent_minutes => 42, :extra_time_hours => 2, :extra_time_minutes => 31, :note => "a test time entry"
    assert !time_entry.save
  end

  test "can't create time entry without task" do
    time_entry = TimeEntry.new :user_id => @user_id, :time_spent_hours => 3, :time_spent_minutes => 42, :extra_time_hours => 2, :extra_time_minutes => 31, :note => "a test time entry"
    assert !time_entry.save
  end

  test "get time entrys user" do
    @time_entry = TimeEntry.find_by_time_spent(222)
    assert_equal @time_entry.user, User.find(1)
    assert_equal @time_entry.user.first_name, "Glen"
  end

  test "get time entrys task" do
    @time_entry = TimeEntry.find_by_time_spent(222)
    assert_equal @time_entry.task, Task.last
    assert_equal @time_entry.task.name, Task.last.name
  end

  # the missing operator will default to 0, so they time will still be created, but blank (this is a Good Thing)
  test "can create time entry without time spent hours" do
    time_entry = TimeEntry.new :user_id => @user_id, :task_id => @task.id, :time_spent_minutes => 42, :extra_time_hours => 2, :extra_time_minutes => 31, :note => "a test time entry"
    assert time_entry.save
  end

  test "can create time entry without time spent minutes" do
    time_entry = TimeEntry.new :user_id => @user_id, :task_id => @task.id, :time_spent_hours => 3, :extra_time_hours => 2, :extra_time_minutes => 31, :note => "a test time entry"
    assert time_entry.save
  end

  test "can create time entry without extra time hours" do
    time_entry = TimeEntry.new :user_id => @user_id, :task_id => @task.id, :time_spent_hours => 3, :time_spent_minutes => 42, :extra_time_minutes => 31, :note => "a test time entry"
    assert time_entry.save
  end

  test "can create time entry without extra time minutes" do
    time_entry = TimeEntry.new :user_id => @user_id, :task_id => @task.id, :time_spent_hours => 3, :time_spent_minutes => 42, :extra_time_hours => 2, :note => "a test time entry"
    assert time_entry.save
  end

  test "can create time entry without note" do
    time_entry = TimeEntry.new :user_id => @user_id, :task_id => @task.id, :time_spent_hours => 3, :time_spent_minutes => 42, :extra_time_hours => 2, :extra_time_minutes => 31
    assert time_entry.save
  end

  test "can create time entry without extra time" do
    time_entry = TimeEntry.new :user_id => @user_id, :task_id => @task.id, :time_spent_hours => 3, :time_spent_minutes => 42, :note => "a test time entry"
    assert time_entry.save
  end

  test "acount time entries" do
    assert_equal TimeEntry.all.size, 12
  end

  include ApplicationHelper

  # test that times will display in our pretty format
  test "check time integer to pretty print 1" do
    assert_equal minutes_to_hours_minutes(180), "3h"
  end

  test "check time integer to pretty print 2" do
    assert_equal minutes_to_hours_minutes(3242), "54h 2m"
  end

  test "check time integer to pretty print 3" do
    assert_equal minutes_to_hours_minutes(321), "5h 21m"
  end

  test "check time integer to pretty print 4" do
    assert_equal minutes_to_hours_minutes(32), "32m"
  end

  test "check time integer to pretty print 5" do
    assert_equal minutes_to_hours_minutes(7), "7m"
  end

  test "check time integer to pretty print 6" do
    assert_equal minutes_to_hours_minutes(0), "0m"
  end

  test "check time integer to pretty print 7" do
    assert_equal minutes_to_hours_minutes(93), "1h 33m"
  end

  test "check time integer to pretty print 8" do
    assert_equal minutes_to_hours_minutes(185), "3h 5m"
  end

  test "check time integer to pretty print 9" do
    assert_equal minutes_to_hours_minutes(32), "32m"
  end

  test "check time integer to pretty print 10" do
    assert_equal minutes_to_hours_minutes(239), "3h 59m"
  end

  test "check all time entries are adding up for tasks" do
    @task = Task.find_by_name("Put more work into the approved design")
    assert_not_nil @task
    assert_equal @task.time_spent, 955
  end

  test "check all time entries are adding up for jobs" do
    @job = Job.find_by_name("New visual design for Microsoft")
    assert_not_nil @job
    assert_equal @job.time_spent, 2860
  end

  test "check budget of a job" do
    @job = Job.find_by_name("New visual design for Microsoft")
    assert_equal @job.budget, 50
  end

  test "check total extra times of a task" do
    @task = Task.find_by_name("Send the new visual design to development for implementation")
    assert_not_nil @task
    assert_equal @task.total_extra_times, 120
  end

  test "check total extra times of a job" do
    @job = Job.find_by_name("New visual design for Microsoft")
    assert_equal @job.total_extra_times, 450
  end

  test "check total task's budgets of a job" do
    @job = Job.find_by_name("New visual design for Microsoft")
    assert_equal @job.total_tasks_budgets, 2820
  end

  test "check remaining of a job" do
    @job = Job.find_by_name("New visual design for Microsoft")
    assert_equal @job.remaining, 410
  end

  test "check forecast of a job" do
    @job = Job.find_by_name("New visual design for Microsoft")
    assert_equal @job.forecast, 3720
  end

  test "check outlook of a job" do
    @job = Job.find_by_name("New visual design for Microsoft")
    assert_equal @job.outlook, -720
  end

  test "check progress of a job" do
    @job = Job.find_by_name("New visual design for Microsoft")
    assert_equal @job.progress, 85
  end

  test "check metric budget of MS job as pretty print" do
    @job = Job.find_by_name("New visual design for Microsoft")
    assert_equal minutes_to_hours_minutes(@job.budget * 60), "50h"
  end

  test "check metric time spent of MS job as pretty print" do
    @job = Job.find_by_name("New visual design for Microsoft")
    assert_equal minutes_to_hours_minutes(@job.time_spent), "47h 40m"
  end

  test "check metric remaining of MS job as pretty print" do
    @job = Job.find_by_name("New visual design for Microsoft")
    assert_equal minutes_to_hours_minutes(@job.remaining), "6h 50m"
  end

  test "check metric forecast of MS job as pretty print" do
    @job = Job.find_by_name("New visual design for Microsoft")
    assert_equal minutes_to_hours_minutes(@job.forecast), "62h"
  end

  test "check metric outlook of MS job as pretty print" do
    @job = Job.find_by_name("New visual design for Microsoft")
    assert_equal minutes_to_hours_minutes(@job.outlook), "-12h"
  end

  #
  test "check metric budget of job" do
    @job = Job.find_by_name("Trickle")
    assert_equal @job.budget, 288
  end

  test "check metric time_spent of job" do
    @job = Job.find_by_name("Trickle")
    assert_equal @job.time_spent, 0
  end

  test "check metric total_tasks_budgets of job" do
    @job = Job.find_by_name("Trickle")
    assert_equal @job.total_tasks_budgets, 16800
  end

  test "check metric total_extra_times of job" do
    @job = Job.find_by_name("Trickle")
    assert_equal @job.total_extra_times, 0
  end

  test "check metric remaining of job" do
    @job = Job.find_by_name("Trickle")
    assert_equal @job.remaining, 16800
  end

  test "check metric foreacast of job" do
    @job = Job.find_by_name("Trickle")
    assert_equal @job.forecast, 16800
  end

  test "check metric outlook of job" do
    @job = Job.find_by_name("Trickle")
    assert_equal @job.outlook, 480
  end

  test "check metric budget of job as pretty print" do
    @job = Job.find_by_name("Trickle")
    assert_equal minutes_to_hours_minutes(@job.budget), "4h 48m"
  end

  test "check metric time spent of job as pretty print" do
    @job = Job.find_by_name("Trickle")
    assert_equal minutes_to_hours_minutes(@job.time_spent), "0m"
  end

  test "check metric remaining of job as pretty print" do
    @job = Job.find_by_name("Trickle")
    assert_equal minutes_to_hours_minutes(@job.remaining), "280h"
  end

  test "check metric forecast of job as pretty print" do
    @job = Job.find_by_name("Trickle")
    assert_equal minutes_to_hours_minutes(@job.forecast), "280h"
  end

  test "check metric outlook of job as pretty print" do
    @job = Job.find_by_name("Trickle")
    assert_equal minutes_to_hours_minutes(@job.outlook), "8h"
  end
end