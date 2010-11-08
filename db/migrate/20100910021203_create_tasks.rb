class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.string      :name, :null => false
      t.integer     :number, :null => false
      t.references  :project, :null => false
      t.timestamp   :start_date
      t.timestamp   :end_date
      t.text        :note
      t.string      :status, :null => false
      t.integer     :budget
      t.boolean     :billable, :null => false
      t.references  :resource_type
      t.integer     :quantity
      t.decimal     :unit_cost
    end
  end

  def self.down
    drop_table :tasks
  end
end