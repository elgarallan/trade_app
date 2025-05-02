class Transaction < ApplicationRecord
  belongs_to :user

  TRANSACTION_TYPES = %w[buy sell]

  validates :transaction_type, presence: true, inclusion: { in: TRANSACTION_TYPES }
  validates :symbol, presence: true
  validates :shares, presence: true, numericality: { greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
