class Transaction < ApplicationRecord
  belongs_to :stock

  validates :quantity, numericality: { greater_than: 0 }
  validates :price, numericality: { greater_than: 0 }
  validates :action, inclusion: { in: %w[buy sell] }
end
