class FixStockColumns < ActiveRecord::Migration[8.0]
  def change
    remove_column :stocks, :company_name, :string
    add_column :stocks, :shares, :integer
  end
end
