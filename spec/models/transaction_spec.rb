require 'rails_helper'

RSpec.describe Transaction, type: :model do
  let(:user) do
    User.create!(
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123",
      cash_balance: 10_000,
      approved: true
    )
  end

  let(:valid_attributes) do
    {
      user: user,
      transaction_type: "buy",
      symbol: "AAPL",
      shares: 10,
      price: 150.0
    }
  end

  describe "associations" do
    it "belongs to a user" do
      association = Transaction.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
    end
  end

  describe "validations" do
    it "is valid with valid attributes" do
      transaction = Transaction.new(valid_attributes)
      expect(transaction).to be_valid
    end

    it "is not valid without a transaction_type" do
      transaction = Transaction.new(valid_attributes.merge(transaction_type: nil))
      expect(transaction).not_to be_valid
      expect(transaction.errors[:transaction_type]).to include("can't be blank")
    end

    it "is not valid with an invalid transaction_type" do
      transaction = Transaction.new(valid_attributes.merge(transaction_type: "invalid_type"))
      expect(transaction).not_to be_valid
      expect(transaction.errors[:transaction_type]).to include("is not included in the list")
    end

    it "is valid with transaction_type 'buy'" do
      transaction = Transaction.new(valid_attributes.merge(transaction_type: "buy"))
      expect(transaction).to be_valid
    end

    it "is valid with transaction_type 'sell'" do
      transaction = Transaction.new(valid_attributes.merge(transaction_type: "sell"))
      expect(transaction).to be_valid
    end

    it "is not valid without a symbol" do
      transaction = Transaction.new(valid_attributes.merge(symbol: nil))
      expect(transaction).not_to be_valid
      expect(transaction.errors[:symbol]).to include("can't be blank")
    end

    it "is not valid without shares" do
      transaction = Transaction.new(valid_attributes.merge(shares: nil))
      expect(transaction).not_to be_valid
      expect(transaction.errors[:shares]).to include("can't be blank")
    end

    it "is not valid with negative shares" do
      transaction = Transaction.new(valid_attributes.merge(shares: -1))
      expect(transaction).not_to be_valid
      expect(transaction.errors[:shares]).to include("must be greater than 0")
    end

    it "is not valid with zero shares" do
      transaction = Transaction.new(valid_attributes.merge(shares: 0))
      expect(transaction).not_to be_valid
      expect(transaction.errors[:shares]).to include("must be greater than 0")
    end

    it "is not valid without a price" do
      transaction = Transaction.new(valid_attributes.merge(price: nil))
      expect(transaction).not_to be_valid
      expect(transaction.errors[:price]).to include("can't be blank")
    end

    it "is not valid with a negative price" do
      transaction = Transaction.new(valid_attributes.merge(price: -1))
      expect(transaction).not_to be_valid
      expect(transaction.errors[:price]).to include("must be greater than or equal to 0")
    end

    it "is valid with a zero price" do
      transaction = Transaction.new(valid_attributes.merge(price: 0))
      expect(transaction).to be_valid
    end

    it "is not valid without a user" do
      transaction = Transaction.new(valid_attributes.merge(user: nil))
      expect(transaction).not_to be_valid
      expect(transaction.errors[:user]).to include("must exist")
    end
  end
end
