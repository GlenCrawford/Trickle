class CreateTimeEntries < ActiveRecord::Migration
  def self.up
    create_table :time_entries do |t|
      t.references    :user, :null => false
      t.references    :task, :null => false
      t.integer       :time_spent, :null => false
      t.integer       :extra_time, :null => false
      t.text          :note, :null => false
      t.timestamp     :created_at, :null => false
    end
  end

  def self.down
    drop_table :time_entries
  end
end