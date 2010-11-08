require 'test_helper'

class ClientTest < ActiveSupport::TestCase
  test "create new client" do
    new_client = Client.new :code => "UCa", :name => "UniversityofCanterbury"
    assert new_client.save
  end

  test "try and create with no name" do
    new_client = Client.new :code => "LCK"
    assert !new_client.save
  end

  test "try and create with no code" do
    new_client = Client.new :name => "LeftClick"
    assert !new_client.save
  end

  test "try and create with nothing" do
    new_client = Client.new
    assert !new_client.save
  end

  test "make sure code is capitalized" do
    new_client = Client.new :code => "lol", :name => "Apple Computer"
    assert new_client.save
    new_client = Client.find_by_code("LOL")
    assert_not_nil new_client
    assert new_client.code == "LOL"
  end
end