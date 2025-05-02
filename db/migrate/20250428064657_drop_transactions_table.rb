class DropTransactionsTable < ActiveRecord::Migration[8.0]
  def change
    if table_exists?(:transactions)
      drop_table :transactions
    end
  end
end
