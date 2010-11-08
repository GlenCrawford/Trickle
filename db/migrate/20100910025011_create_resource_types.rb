class CreateResourceTypes < ActiveRecord::Migration
  def self.up
    create_table :resource_types do |t|
      t.string    :code, :null => false
      t.string    :name, :null => false
      t.decimal   :rate, :null => false
    end
  end

  def self.down
    drop_table :resource_types
  end
end