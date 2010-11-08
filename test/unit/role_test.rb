require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  test "should not save without name" do
    @role = Role.new :description => "An unpaid student, working full-time anyway."
    assert !@role.save
  end

  test "should not save without description" do
    @role = Role.new :name => "Office temp"
    assert !@role.save
  end

  test "should be four roles" do
    @roles = Role.find(:all)
    assert @roles.size == 4
  end

  test "should save" do
    @role = Role.new :name => "Office temp", :description => "An unpaid student, working full-time anyway."
    assert @role.save
  end
end