class AddCashBalanceToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :cash_balance, :decimal, default: 10000.0
  end
end
