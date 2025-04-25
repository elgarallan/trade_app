class CreateStocks < ActiveRecord::Migration[8.0]
  def change
    create_table :stocks do |t|
      t.references :user, null: false, foreign_key: true
      t.string :symbol
      t.string :company_name

      t.timestamps
    end
  end
end
