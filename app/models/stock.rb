class Stock < ApplicationRecord
  belongs_to :user
  has_many :transactions, dependent: :destroy

  validates :symbol, presence: true, uniqueness: { scope: :user_id }
  validates :name, presence: true
end
