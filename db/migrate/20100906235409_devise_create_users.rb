class DeviseCreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.database_authenticatable :null => false
      t.rememberable

      t.string    :first_name, :null => false
      t.string    :last_name, :null => false
      t.string    :nick_name
      t.string    :username, :null => false
      t.string    :telephone_number
      t.string    :mobile_number
      t.string    :avatar, :null => false

      t.references :role, :null => false
    end
  end

  def self.down
    drop_table :users
  end
end