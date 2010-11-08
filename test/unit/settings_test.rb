require 'test_helper'

class SettingsTest < ActiveSupport::TestCase
  def setup
    @settings = Settings.get
  end

  test "get our settings" do
    assert_not_nil @settings
  end

  test "get all settings" do
    @all_settings = Settings.all
    assert @all_settings.size == 2
  end

  test "check all settings are filled" do
    assert_not_nil @settings.daily_resource_amount
    assert_not_nil @settings.billable
    assert_not_nil @settings.company_code
    assert_not_nil @settings.company_name
    assert_not_nil @settings.low_utilization_level
    assert_not_nil @settings.high_utilization_level
  end

  test "create new settings" do
    @new_settings = Settings.new :daily_resource_amount => 50, :billable => 1, :company_code => "LCK", :company_name => "LeftClick", :low_utilization_level => 20, :high_utilization_level => 80
    assert @new_settings.save

    @settings = Settings.last
    assert @settings.daily_resource_amount == 50
    assert @settings.billable == true
    assert @settings.company_code == "LCK"
    assert @settings.company_name == "LeftClick"
    assert @settings.low_utilization_level == 20
    assert @settings.high_utilization_level == 80
  end
end