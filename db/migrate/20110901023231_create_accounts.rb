class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.string :username
      t.string :hashedpass
      t.integer :artist
      t.integer :permission
      t.string :salt

      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end
