class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :symbol
      t.string :transaction_type
      t.integer :shares
      t.decimal :price

      t.timestamps
    end
  end
end
