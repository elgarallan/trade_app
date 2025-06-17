# frozen_string_literal: true

class AddDeviseToUsers < ActiveRecord::Migration[8.0]
  def self.up
    # Add only the missing Devise columns outside of change_table
    add_column :users, :reset_password_sent_at, :datetime unless column_exists?(:users, :reset_password_sent_at)
    add_column :users, :remember_created_at, :datetime unless column_exists?(:users, :remember_created_at)

    # Optional Devise modules: trackable, confirmable, lockable (commented out unless needed)
    # add_column :users, :sign_in_count, :integer, default: 0, null: false unless column_exists?(:users, :sign_in_count)
    # add_column :users, :current_sign_in_at, :datetime unless column_exists?(:users, :current_sign_in_at)
    # add_column :users, :last_sign_in_at, :datetime unless column_exists?(:users, :last_sign_in_at)
    # add_column :users, :current_sign_in_ip, :string unless column_exists?(:users, :current_sign_in_ip)
    # add_column :users, :last_sign_in_ip, :string unless column_exists?(:users, :last_sign_in_ip)

    # Add only missing indexes
    # add_index :users, :reset_password_token, unique: true unless index_exists?(:users, :reset_password_token)
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
