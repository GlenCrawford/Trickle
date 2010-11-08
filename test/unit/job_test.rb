require 'test_helper'

class JobTest < ActiveSupport::TestCase
  def setup
    @client = Client.find_by_name("Sony")
    @owner = User.find_by_first_name("Glen")
    @user = User.find_by_first_name("Glen")
    user_ids = []
    User.all.each do |user|
      user_ids << user.id
    end
    @job_data = {:name => "My test job", :budget => 592, :client_id => @client.id, :owner_id => @owner.id, :user_ids => user_ids}
    @task_data = [
      {:name => "First task", :note => "A good 1st task", :billable => true, :budget => 34, :status => "open", :user_ids => [@user.id]},
      {:name => "Second task", :note => "A good 2nd task", :billable => true, :budget => 68, :status => "completed", :user_ids => [@user.id]},
      {:name => "Third task", :note => "A good 3rd task", :billable => true, :budget => 102, :status => "open", :user_ids => [@user.id]}
    ]
  end

  test "acreate first job" do
    @job = Job.new @job_data
    assert_difference("Job.count") do
      assert @job.save
    end
  end

  test "acreate first job tasks" do
    @job = Job.find_by_name(@job_data[:name])
    assert_not_nil @job
    @task_data.each do |this_task_data|
      this_task_data[:project_id] = @job.id
      assert_difference("Task.count") do
        @new_task = Task.new this_task_data
        assert @new_task.save
      end
    end
  end

  test "can't create job without name" do
    @job_data.delete(:name)
    @job = Job.new @job_data
    assert !@job.save
  end

  test "can't create job without budget" do
    @job_data.delete(:budget)
    @job = Job.new @job_data
    assert !@job.save
  end

  test "can't create job without client" do
    @job_data.delete(:client_id)
    @job = Job.new @job_data
    assert !@job.save
  end

  test "can't create job without owner" do
    @job_data.delete(:owner_id)
    @job = Job.new @job_data
    assert !@job.save
  end

  test "can't create job without users" do
    @job_data.delete(:user_ids)
    @job = Job.new @job_data
    assert !@job.save
  end

  test "can't create job with empty users" do
    @job_data[:user_ids] = []
    @job = Job.new @job_data
    assert !@job.save
  end

  test "can't create job with zero budget" do
    @job_data[:budget] = 0
    @job = Job.new @job_data
    assert !@job.save
  end

  test "can't create job with negative budget" do
    @job_data[:budget] = -5
    @job = Job.new @job_data
    assert !@job.save
  end

  test "can't create job with decimal client id" do
    @job_data[:client_id] = 6.3
    @job = Job.new @job_data
    assert !@job.save
  end

  test "can't create job with decimal budget" do
    @job_data[:budget] = 7.1
    @job = Job.new @job_data
    assert !@job.save
  end

  test "can't create job with decimal owner id" do
    @job_data[:owner_id] = 43.2
    @job = Job.new @job_data
    assert !@job.save
  end

  test "can't create job with string client id" do
    @job_data[:client_id] = "df6"
    @job = Job.new @job_data
    assert !@job.save
  end

  test "can't create job with string budget" do
    @job_data[:budget] = "2f5"
    @job = Job.new @job_data
    assert !@job.save
  end

  test "can't create job with string owner id" do
    @job_data[:owner_id] = "djf4"
    @job = Job.new @job_data
    assert !@job.save
  end

  test "can't create job with string estimate id" do
    @job_data[:estimate_id] = "6s2"
    @job = Job.new @job_data
    assert !@job.save
  end

  test "can't create job with decimal estimate id" do
    @job_data[:estimate_id] = 543.2
    @job = Job.new @job_data
    assert !@job.save
  end

  test "get owner" do
    @job = Job.find_by_name(@job_data[:name])
    assert_not_nil @job
    assert_not_nil @job.owner
    assert_equal @job.owner_id, @owner.id
    assert_equal @job.owner.id, @owner.id
    assert_equal @job.owner.name, "Glen Crawford"
  end

  test "get client" do
    @job = Job.find_by_name(@job_data[:name])
    assert_not_nil @job
    assert_not_nil @job.client
    assert_equal @job.client_id, @client.id
    assert_equal @job.client.id, @client.id
    assert_equal @job.client.name, "Sony"
  end

  test "get creator" do
    @job = Job.find_by_name(@job_data[:name])
    assert_not_nil @job
    assert_not_nil @job.creator
    assert_equal @job.creator_id, @user.id
    assert_equal @job.creator.id, @user.id
    assert_equal @job.creator.name, @user.name
  end

  test "get updater" do
    @job = Job.find_by_name(@job_data[:name])
    assert_not_nil @job
    assert_not_nil @job.updater
    assert_equal @job.updater_id, @user.id
    assert_equal @job.updater.id, @user.id
    assert_equal @job.updater.name, @user.name
  end

  test "get estimate" do
    @job = Job.find_by_name(@job_data[:name])
    assert_not_nil @job
    assert !@job.estimate_id
    assert !@job.estimate
  end

  test "get job" do
    @job = Job.find_by_name(@job_data[:name])
    assert_not_nil @job
    assert_equal @job.type, "Job"
    assert_equal @job.name, @job_data[:name]
    assert_equal @job.number.class.name, "String"
    assert_equal @job.budget, @job_data[:budget]
    assert_equal @job.status, "open"
  end

  test "get users" do
    @job = Job.find_by_name(@job_data[:name])
    assert_not_nil @job
    assert_not_nil @job.users
    assert_equal @job.users.size, User.all.size
    assert_equal @job.users[0].name, User.first.name
    assert_equal @job.users[@job.users.size - 1].name, User.last.name
    assert_not_nil @job.created_at
    assert_not_nil @job.updated_at
  end

  test "get tasks" do
    @job = Job.find_by_name(@job_data[:name])
    assert_not_nil @job
    assert_not_nil @job.tasks
    assert_equal @job.tasks.size, @task_data.size
    @job.tasks.each do |task|
      assert_equal task.project, @job
    end
  end

  test "check job numbers" do
    @job = Job.find_by_name(@job_data[:name])
    assert_not_nil @job
    assert_equal @job.client_id.class.name, "Fixnum"
    assert_equal @job.budget.class.name, "Fixnum"
  end

  test "check estimate id not present" do
    @job = Job.find_by_name(@job_data[:name])
    assert_not_nil @job
    assert !@job.estimate_id_present?
  end

  test "check owner id present" do
    @job = Job.find_by_name(@job_data[:name])
    assert_not_nil @job
    assert @job.owner_id_present?
  end

  test "check is not estimate" do
    @job = Job.find_by_name(@job_data[:name])
    assert_not_nil @job
    assert !@job.is_estimate?
  end

  test "check is job" do
    @job = Job.find_by_name(@job_data[:name])
    assert_not_nil @job
    assert @job.is_job?
  end

  test "zdelete job, check tasks delete too" do
    @job = Job.find_by_name(@job_data[:name])
    assert_not_nil @job
    assert_difference("Project.count", -1) do
      assert_difference("Job.count", -1) do
        assert_difference("Task.count", (@task_data.size * -1)) do
          @job.destroy
        end
      end
    end
  end
end