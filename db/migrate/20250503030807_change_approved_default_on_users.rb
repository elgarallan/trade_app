class ChangeApprovedDefaultOnUsers < ActiveRecord::Migration[8.0]
  def change
    change_column_default :users, :approved, false
    change_column_null :users, :approved, false, false
  end
end
