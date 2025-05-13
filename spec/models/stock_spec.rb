require 'rails_helper'

RSpec.describe Stock, type: :model do
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
      user: user
    }
  end

  describe "associations" do
    it "belongs to a user" do
      association = Stock.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
    end
  end

  describe "validations" do
    it "is valid with valid attributes" do
      stock = Stock.new(valid_attributes)
      expect(stock).to be_valid
    end

    it "is not valid without a user" do
      stock = Stock.new(valid_attributes.merge(user: nil))
      expect(stock).not_to be_valid
      expect(stock.errors[:user]).to include("must exist")
    end
  end
end
