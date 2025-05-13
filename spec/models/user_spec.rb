require 'rails_helper'

RSpec.describe User, type: :model do
  let(:valid_attributes) do
    {
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123",
      admin: false,
      approved: true
    }
  end

  describe "associations" do
    it "has many stocks" do
      association = User.reflect_on_association(:stocks)
      expect(association.macro).to eq :has_many
    end

    it "has many transactions" do
      association = User.reflect_on_association(:transactions)
      expect(association.macro).to eq :has_many
    end
  end

  describe "validations" do
    it "is valid with valid attributes" do
      user = User.new(valid_attributes)
      expect(user).to be_valid
    end

    it "is not valid without an email" do
      user = User.new(valid_attributes.merge(email: nil))
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it "is not valid with an invalid email format" do
      user = User.new(valid_attributes.merge(email: "invalid-email"))
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("is invalid")
    end

    it "is not valid without a password" do
      user = User.new(valid_attributes.merge(password: nil))
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("can't be blank")
    end

    it "is not valid with a short password" do
      user = User.new(valid_attributes.merge(password: "short", password_confirmation: "short"))
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("is too short (minimum is 6 characters)")
    end

    it "is not valid when passwords don't match" do
      user = User.new(valid_attributes.merge(password_confirmation: "different"))
      expect(user).not_to be_valid
      expect(user.errors[:password_confirmation]).to include("doesn't match Password")
    end

    it "enforces email uniqueness" do
      User.create!(valid_attributes)
      duplicate_user = User.new(valid_attributes)
      expect(duplicate_user).not_to be_valid
      expect(duplicate_user.errors[:email]).to include("has already been taken")
    end
  end

  describe "#admin?" do
    it "returns true if user is an admin" do
      admin_user = User.new(valid_attributes.merge(admin: true))
      expect(admin_user.admin?).to be true
    end

    it "returns false if user is not an admin" do
      trader_user = User.new(valid_attributes.merge(admin: false))
      expect(trader_user.admin?).to be false
    end
  end

  describe "#trader?" do
    it "returns true if user is not an admin" do
      trader_user = User.new(valid_attributes.merge(admin: false))
      expect(trader_user.trader?).to be true
    end

    it "returns false if user is an admin" do
      admin_user = User.new(valid_attributes.merge(admin: true))
      expect(admin_user.trader?).to be false
    end
  end

  describe "#active_for_authentication?" do
    it "returns true if user is approved" do
      approved_user = User.new(valid_attributes.merge(approved: true))
      expect(approved_user.active_for_authentication?).to be true
    end

    it "returns false if user is not approved" do
      unapproved_user = User.new(valid_attributes.merge(approved: false))
      expect(unapproved_user.active_for_authentication?).to be false
    end
  end

  describe "#inactive_message" do
    it "returns :not_approved if user is not approved" do
      unapproved_user = User.new(valid_attributes.merge(approved: false))
      expect(unapproved_user.inactive_message).to eq :not_approved
    end

    it "returns super result if user is approved" do
      approved_user = User.create!(valid_attributes.merge(approved: true))
      expect(approved_user.inactive_message).not_to eq :not_approved
    end
  end

  describe "Devise functionality" do
    it "authenticates with valid credentials" do
      user = User.create!(valid_attributes)
      authenticated_user = User.find_for_authentication(email: "test@example.com")
      expect(authenticated_user).to eq(user)
      expect(authenticated_user.valid_password?("password123")).to be true
    end

    it "does not authenticate with invalid credentials" do
      user = User.create!(valid_attributes)
      expect(user.valid_password?("wrong_password")).to be false
    end
  end

  describe "association behavior" do
    it "can have many stocks" do
      user = User.create!(valid_attributes)
      stock1 = user.stocks.create!
      stock2 = user.stocks.create!

      expect(user.stocks.count).to eq 2
      expect(user.stocks).to include(stock1, stock2)
    end

    it "can have many transactions" do
      user = User.create!(valid_attributes)
      transaction1 = user.transactions.create!(
        transaction_type: "buy",
        symbol: "AAPL",
        shares: 10,
        price: 150.0
      )
      transaction2 = user.transactions.create!(
        transaction_type: "sell",
        symbol: "MSFT",
        shares: 5,
        price: 200.0
      )

      expect(user.transactions.count).to eq 2
      expect(user.transactions).to include(transaction1, transaction2)
    end
  end
end
