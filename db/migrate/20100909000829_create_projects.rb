class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string          :type, :null => false
      t.string          :name, :null => false
      t.string          :number, :null => false
      t.integer         :budget
      t.string          :status, :null => false
      t.references      :client, :null => false
      t.references      :estimate
      t.integer         :owner_id
      t.integer         :creator_id, :null => false
      t.timestamp       :created_at, :null => false
      t.integer         :updater_id, :null => false
      t.timestamp       :updated_at, :null => false
    end
  end

  def self.down
    drop_table :projects
  end
end