class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.integer     :thing_id, :null => false
      t.string      :thing_type, :null => false
      t.string      :action, :null => false
      t.timestamp   :action_date, :null => false

      t.references  :user, :null => false
    end
  end

  def self.down
    drop_table :activities
  end
end