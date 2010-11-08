class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table :settings do |t|
      t.integer     :daily_resource_amount, :null => false
      t.boolean     :billable, :null => false
      t.string      :company_code, :null => false
      t.string      :company_name, :null => false
      t.integer     :low_utilization_level, :null => false
      t.integer     :high_utilization_level, :null => false
    end
  end

  def self.down
    drop_table :settings
  end
end