require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  test "get first task" do
    @task = Task.find_by_name("Monitor progress on their site")

    assert_not_nil @task
    assert_equal @task.name, "Monitor progress on their site"
    assert_equal @task.number, 3
    assert_equal @task.project_id, 1
    assert_equal @task.note, "One hour a week for two weeks"
    assert_equal @task.status, "open"
    # is an estimate task, so no budget (will get it when converted to a job)
    assert_equal @task.budget, nil
    assert_equal @task.billable, true
    assert_equal @task.resource_type_id, 4
    assert_equal @task.quantity, 1
    assert_equal @task.unit_cost, 170
  end

  test "get first task's project" do
    @task = Task.find_by_name("Monitor progress on their site")
    assert_not_nil @task
    assert_equal @task.project_id, 1
  end

  test "check numbers auto_increment" do
    @estimate_first = Estimate.first
    assert_not_nil @estimate_first
    @new_task = Task.new :name => "Another task", :project_id => @estimate_first.id, :note => "Another note", :billable => 1, :resource_type_id => 3, :quantity => 5
    assert @new_task.save
    assert_equal @new_task.number, 5
  end

  test "get first task's resource type" do
    @task = Task.find_by_name("Monitor progress on their site")
    @resource_type = ResourceType.find @task.resource_type_id

    assert_not_nil @task
    assert_not_nil @resource_type

    assert_equal @resource_type.id, 4
    assert_equal @resource_type.code, "SEO"
    assert_equal @resource_type.name, "Search engine optimizer"
    assert_equal @resource_type.rate, 170
  end

  test "check first task's unit cost" do
    @task = Task.find_by_name("Monitor progress on their site")

    assert_not_nil @task
    assert_equal (ResourceType.find(@task.resource_type_id).rate * @task.quantity), @task.unit_cost
  end
end