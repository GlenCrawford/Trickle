require 'test_helper'

class ResourceTypeTest < ActiveSupport::TestCase
  test "count seeded resource types" do
    assert ResourceType.all.size == 5
  end

  test "get first resource type" do
    @resource_type = ResourceType.first

    assert_not_nil @resource_type
    assert_equal @resource_type.code, "DEV"
    assert_equal @resource_type.name, "Developer"
    assert_equal @resource_type.rate, 200
  end

  test "a_get last resource type" do
    @resource_type = ResourceType.last

    assert_not_nil @resource_type
    assert_equal @resource_type.code, "OMC"
    assert_equal @resource_type.name, "Online marketing consultant"
    assert_equal @resource_type.rate, 190
  end

  test "create new resource type" do
    @resource_type = ResourceType.new :code => "STU", :name => "Student", :rate => 1
    assert_difference("ResourceType.count") do
      assert @resource_type.save
    end
  end

  test "can't save resource type without code" do
    @resource_type = ResourceType.new :name => "Programmer", :rate => 250
    assert !@resource_type.save
  end

  test "can't save resource type without name" do
    @resource_type = ResourceType.new :code => "PRO", :rate => 250
    assert !@resource_type.save
  end

  test "can't save resource type without rate" do
    @resource_type = ResourceType.new :code => "PRO", :name => "Programmer"
    assert !@resource_type.save
  end

  test "can't create resource type with duplicate code" do
    @resource_type = ResourceType.new :code => "DEV", :name => "Programmer", :rate => 250
    assert !@resource_type.save
  end

  test "can't create resource type with duplicate name" do
    @resource_type = ResourceType.new :code => "PRM", :name => "Online marketing consultant", :rate => 250
    assert !@resource_type.save
  end

  test "can't create new resource type with negative rate" do
    @resource_type = ResourceType.new :code => "DSF", :name => "dsfloldsf", :rate => -5
    assert !@resource_type.save
  end

  test "can't create new resource type with non number rate" do
    @resource_type = ResourceType.new :code => "DSF", :name => "dsfloldsf", :rate => "5g"
    assert !@resource_type.save
  end
end