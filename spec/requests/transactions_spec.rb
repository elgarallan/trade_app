require 'rails_helper'

RSpec.describe "Transactions", type: :request do
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
      symbol: "AAPL",
      transaction_type: "buy",
      shares: 2,
      price: 150.0
    }
  end

  describe "GET /index" do
    it "returns a success response" do
      post user_session_path, params: {
        user: {
          email: user.email,
          password: "password123"
        }
      }

      get transactions_path
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      before do
        post user_session_path, params: {
          user: {
            email: user.email,
            password: "password123"
          }
        }
      end

      it "creates a new Transaction" do
        expect {
          post transactions_path, params: valid_attributes
        }.to change(Transaction, :count).by(1)
      end

      it "redirects to the transactions list" do
        post transactions_path, params: valid_attributes
        expect(response).to redirect_to(transactions_path)
      end

      it "sets a success notice" do
        post transactions_path, params: valid_attributes
        expect(flash[:notice]).to eq("Transaction was successfully placed.")
      end

      it "associates the transaction with the current user" do
        post transactions_path, params: valid_attributes
        expect(Transaction.last.user).to eq(user)
      end
    end
  end
end
