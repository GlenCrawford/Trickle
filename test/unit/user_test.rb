require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "get seeded user" do
    @user = User.find_by_username("Glen")

    assert_not_nil @user

    assert @user.first_name == "Glen"
    assert @user.last_name == "Crawford"
    assert @user.nick_name == "Glen"
    assert @user.email == "glc233@student.cpit.ac.nz"
    assert @user.username == "glen"
    assert @user.telephone_number == "03 376 6285"
    assert @user.mobile_number == "027 423 9864"
    assert @user.avatar == "/images/avatars/glen.gif"
    assert @user.role.name == "Administrator"
  end

  test "create user fail no names" do
    user = User.new :nickname => "Glen", :email => "glen@leftclick.com", :telephone_number => "03 313 9548", :mobile_number => "027 554 9434", :encrypted_password => "gc54321", :role_id => 2, :username => "glenbo"
    assert !user.save
  end

  test "create user" do
    user = User.new :first_name => "Chris", :last_name => "Bartlett", :nick_name => "Chris", :email => "chris@leftclick.com", :password => "gc543210", :role_id => 3, :username => "chris", :telephone_number => "03 313 9548", :mobile_number => "027 554 9434", :avatar => "http://www.2flashgames.com/2fgkjn134kjlh1cfn81vc34/flash/f-Serious-Bag-6412.jpg"
    assert user.save
  end

  test "check admin rights" do
    @user = User.first
    assert @user.has_admin_rights
  end
end