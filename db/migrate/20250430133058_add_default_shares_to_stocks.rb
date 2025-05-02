class AddDefaultSharesToStocks < ActiveRecord::Migration[8.0]
  def change
    change_column_default :stocks, :shares, from: nil, to: 0
  end
end
