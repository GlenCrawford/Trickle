class CreateTasksUsers < ActiveRecord::Migration
  def self.up
    create_table :tasks_users, :id => false do |t|
      t.references    :task, :null => false
      t.references    :user, :null => false
    end
  end

  def self.down
    drop_table :tasks_users
  end
end