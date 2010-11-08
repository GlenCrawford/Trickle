require 'test_helper'

# don't forget to check resolving owners when i do jobs

class EstimateTest < ActiveSupport::TestCase
  def setup
    Thread.current[:user] = User.first
    @user_data = {:client_id => Client.first.id, :name => "Test", :number => "2", :budget => 45, :creator_id => 1, :created_at => Time.now, :updater_id => 1, :updated_at => Time.now, :status => "open", :estimate_id => Estimate.find_by_name("SEO for Sony").id, :owner_id => 1}
  end

  test "acount estimates" do
    @estimates = Estimate.all
    assert_equal @estimates.size, 1
  end

  test "create estimate" do
    @current_last_number = Estimate.last.number
    @estimate = Estimate.new @user_data
    assert @estimate.save
  end

  test "find estimate" do
    @estimate = Estimate.find_by_name(@user_data[:name])
    assert_not_nil @estimate

    assert_equal @estimate.type, "Estimate"
    assert_equal @estimate.client_id, Client.first.id
    assert_equal @estimate.client.code, Client.first.code
    assert_equal @estimate.client.name, Client.first.name
    assert_equal @estimate.name, "Test"
    assert_equal @estimate.number, "2"
    assert_equal @estimate.budget, 45
    assert_equal @estimate.creator_id, 1
    assert_equal @estimate.creator.name, "Glen Crawford"
    assert_equal @estimate.created_at.class.name, "Time"
    assert_equal @estimate.updater_id, 1
    assert_equal @estimate.updater.name, "Glen Crawford"
    assert_equal @estimate.updated_at.class.name, "Time"
    assert_equal @estimate.status, "open"
    assert_equal @estimate.estimate.name, "SEO for Sony"
    assert_equal @estimate.owner_id, 1
  end

  test "test generating number" do
    @estimate = Estimate.find_by_name(@user_data[:name])
    assert_equal @current_last_number.to_i + 1, @estimate.number.to_i - 1
  end

  test "fail creating estimate without client" do
    @user_data.delete(:client_id)
    @estimate = Estimate.new @user_data
    assert !@estimate.save
  end

  test "fail creating estimate without name" do
    @user_data.delete(:name)
    @estimate = Estimate.new @user_data
    assert !@estimate.save
  end

  test "fail creating estimate without budget" do
    @user_data.delete(:budget)
    @estimate = Estimate.new @user_data
    assert !@estimate.save
  end

  test "fail creating estimate with decimal client id" do
    @user_data[:client_id] = 5.4
    @estimate = Estimate.new @user_data
    assert !@estimate.save
  end

  test "fail creating estimate with string budget" do
    @user_data[:budget] = "lol"
    @estimate = Estimate.new @user_data
    assert !@estimate.save
  end

  test "fail creating estimate with negative budget" do
    @user_data[:budget] = -99
    @estimate = Estimate.new @user_data
    assert !@estimate.save
  end

  test "fail creating estimate with string estimate" do
    @user_data[:estimate_id] = "lol"
    @estimate = Estimate.new @user_data
    assert !@estimate.save
  end

  test "fail creating estimate with string owner" do
    @user_data[:owner_id] = "lol"
    @estimate = Estimate.new @user_data
    assert !@estimate.save
  end

  test "is estimate" do
    @estimate = Estimate.find_by_name(@user_data[:name])
    assert @estimate.is_estimate?
  end

  test "is not job" do
    @estimate = Estimate.find_by_name(@user_data[:name])
    assert !@estimate.is_job?
  end

  test "resolving client" do
    @estimate = Estimate.find_by_name(@user_data[:name])

    assert_not_nil @estimate.client
    assert_equal @estimate.client.class.name, "Client"
    assert_equal @estimate.client.code, Client.first.code
    assert_equal @estimate.client.name, Client.first.name
  end

  test "resolving creator" do
    @estimate = Estimate.find_by_name(@user_data[:name])

    assert_not_nil @estimate.creator
    assert_equal @estimate.creator.class.name, "User"
    assert_equal @estimate.creator.name, "Glen Crawford"
  end

  test "resolving updater" do
    @estimate = Estimate.find_by_name(@user_data[:name])

    assert_not_nil @estimate.updater
    assert_equal @estimate.updater.class.name, "User"
    assert_equal @estimate.updater.name, "Glen Crawford"
  end

  test "resolving estimate" do
    @estimate = Estimate.find_by_name(@user_data[:name])

    assert_not_nil @estimate.estimate
    assert_equal @estimate.estimate.class.name, "Estimate"
    assert_equal @estimate.estimate.name, "SEO for Sony"
  end
end