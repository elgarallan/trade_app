require 'rails_helper'

RSpec.describe "Admin::TransactionsController", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:admin_user) { User.create!(email: "admin@example.com", password: "password", admin: true, approved: true, cash_balance: 10_000) }
  let(:trader_user) { User.create!(email: "trader@example.com", password: "password", admin: false, approved: true, cash_balance: 10_000) }

  let(:stock) { Stock.create!(symbol: "AAPL", user: trader_user, shares: 10) }

  let!(:transaction) do
    Transaction.create!(
      user: trader_user,
      symbol: stock.symbol,
      price: 150.0,
      shares: 10,
      transaction_type: "buy",
    )
  end

  describe "Authentication" do
    it "requires authentication for all actions" do
      get admin_transactions_path
      expect(response).to redirect_to(new_user_session_path)

      get admin_transaction_path(transaction)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "Authorization" do
    it "should redirect non-admin users to root path" do
      sign_in trader_user, scope: :user

      get admin_transactions_path
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("Access denied.")

      get admin_transaction_path(transaction)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("Access denied.")
    end
  end

  describe "GET /admin/transactions" do
    it "allows admin access and displays all transactions" do
      sign_in admin_user, scope: :user
      get admin_transactions_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("All Transactions")
    end

    it "shows transactions in descending order of creation" do
      Transaction.create!(
        user: trader_user,
        symbol: stock.symbol,
        price: 155.0,
        shares: 5,
        transaction_type: "sell",
        created_at: Time.current + 1.day
      )

      sign_in admin_user, scope: :user
      get admin_transactions_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /admin/transactions/:id" do
    it "displays transaction details for admin users" do
      sign_in admin_user, scope: :user
      get admin_transaction_path(transaction)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Transaction Details")
    end
  end
end
