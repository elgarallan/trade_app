require 'rails_helper'

RSpec.describe "Dashboards", type: :request do
  let(:user) do
    User.create!(
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123",
      approved: true
    )
  end

  let!(:apple_stock) do
    Stock.create!(symbol: 'AAPL', shares: 10, user: user)
  end

  let!(:microsoft_stock) do
    Stock.create!(symbol: 'MSFT', shares: 5, user: user)
  end

  let!(:transaction) do
    Transaction.create!(
      user: user,
      symbol: 'AAPL',
      transaction_type: 'buy',
      shares: 5,
      price: 150.0
    )
  end

  # Set up mocked API responses
  let(:api_response_success) do
    {
      "Time Series (5min)" => {
        "2023-01-01 16:00:00" => {
          "1. open" => "150.00",
          "2. high" => "151.00",
          "3. low" => "149.00",
          "4. close" => "150.50",
          "5. volume" => "1000000"
        }
      }
    }
  end

  let(:api_response_tesla) do
    {
      "Time Series (5min)" => {
        "2023-01-01 16:00:00" => {
          "1. open" => "250.00",
          "2. high" => "251.00",
          "3. low" => "249.00",
          "4. close" => "250.50",
          "5. volume" => "500000"
        }
      }
    }
  end

  let(:api_response_error) do
    { "Error Message" => "Invalid API call" }
  end

  describe "GET /index" do
    context "when user is logged in" do
      before do
        post user_session_path, params: {
          user: {
            email: user.email,
            password: "password123"
          }
        }

        allow(AvaApi).to receive(:fetch_records).with('AAPL').and_return(api_response_success)
        allow(AvaApi).to receive(:fetch_records).with('MSFT').and_return(api_response_success)

        allow(Rails.cache).to receive(:read).and_return(nil)
        allow(Rails.cache).to receive(:write)

        allow_any_instance_of(DashboardController).to receive(:sleep)
      end

      it "returns a successful response" do
        get dashboard_path
        expect(response).to have_http_status(200)
      end

      it "displays the user's transactions" do
        get dashboard_path
        expect(response.body).to include("AAPL")
        expect(response.body).to include("MSFT")
      end

      it "displays the user's stocks" do
        get dashboard_path
        expect(response.body).to include('AAPL')
        expect(response.body).to include('MSFT')
      end

      it "fetches current prices for user's stocks" do
        expect(AvaApi).to receive(:fetch_records).with('AAPL').once
        expect(AvaApi).to receive(:fetch_records).with('MSFT').once
        get dashboard_path
      end
    end
  end
end
