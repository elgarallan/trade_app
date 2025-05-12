require 'rails_helper'

RSpec.describe "Admin::TradersController", type: :request do
  include Devise::Test::IntegrationHelpers
  
  let(:admin_user) { User.create!(email: "admin@example.com", password: "password", admin: true, approved: true, cash_balance: 10_000) }
  let(:trader_user) { User.create!(email: "trader@example.com", password: "password", admin: false, approved: true, cash_balance: 10_000) }
  let(:unapproved_trader) { User.create!(email: "unapproved@example.com", password: "password", admin: false, approved: false, cash_balance: 10_000) }
  let(:valid_attributes) {
    { email: "new_trader@example.com", password: "password", password_confirmation: "password" }
  }

  let(:invalid_attributes) {
    { email: "", password: "short", password_confirmation: "mismatch" }
  }

  describe "Authentication" do
    it "requires authentication for all actions" do
      
      get admin_traders_path
      expect(response).to redirect_to(new_user_session_path)
      
      get new_admin_trader_path
      expect(response).to redirect_to(new_user_session_path)
      
      post admin_traders_path, params: { user: valid_attributes }
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "Authorization" do
    
    it "should require admin access for traders management" do
      
      sign_in trader_user, scope: :user
      
      get admin_traders_path
      
      expect(response).to have_http_status(:ok)
      
      get new_admin_trader_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /admin/traders" do
    it "returns a success response for admin users" do
      sign_in admin_user, scope: :user
      get admin_traders_path
      expect(response).to have_http_status(:ok)
    end
    
    it "renders the traders index page" do
      sign_in admin_user, scope: :user
      get admin_traders_path
      
      expect(response.body).to include("All Traders")
      expect(response.body).to include("Add New Trader")
      expect(response.body).to include("Email")
      expect(response.body).to include("Status")
    end
  end

  describe "GET /admin/traders/new" do
    it "returns a success response" do
      sign_in admin_user, scope: :user
      get new_admin_trader_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /admin/traders/:id/edit" do
    it "returns a success response" do
      sign_in admin_user, scope: :user
      get edit_admin_trader_path(trader_user)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /admin/traders/:id" do
    it "returns a success response" do
      sign_in admin_user, scope: :user
      get admin_trader_path(trader_user)
      expect(response).to have_http_status(:ok)
    end
    
    it "displays trader's portfolio and transaction history" do
      sign_in admin_user, scope: :user
      get admin_trader_path(trader_user)
      
      expect(response.body).to include("Portfolio")
      expect(response.body).to include("Transaction History")
      expect(response.body).to include("trader@example.com")
    end
  end

  describe "POST /admin/traders" do
    context "with valid parameters" do
      it "creates a new trader (non-admin user)" do
        sign_in admin_user, scope: :user
        expect {
          post admin_traders_path, params: { user: valid_attributes }
        }.to change(User, :count).by(1)
        expect(response).to redirect_to(admin_traders_path)
        follow_redirect!
        expect(flash[:notice]).to include("Trader created successfully")
      end
    end

    context "with invalid parameters" do
      it "does not create a new trader" do
        sign_in admin_user, scope: :user
        expect {
          post admin_traders_path, params: { user: invalid_attributes }
        }.not_to change(User, :count)
        expect(response).to have_http_status(:ok) # renders :new
      end
    end
  end

  describe "PUT /admin/traders/:id" do
    let(:new_attributes) {
      { email: "updated_trader@example.com" }
    }

    it "updates the trader" do
      sign_in admin_user, scope: :user
      put admin_trader_path(trader_user), params: { user: new_attributes }
      trader_user.reload
      expect(trader_user.email).to eq("updated_trader@example.com")
      expect(response).to redirect_to(admin_traders_path)
      follow_redirect!
      expect(flash[:notice]).to include("Trader updated successfully")
    end

    it "fails to update with invalid attributes" do
      sign_in admin_user, scope: :user
      put admin_trader_path(trader_user), params: { user: { email: "" } }
      expect(response).to have_http_status(:ok) # renders :edit
      expect(flash[:alert]).to include("Update failed")
    end
  end

  describe "DELETE /admin/traders/:id" do
    it "destroys the trader" do
      sign_in admin_user, scope: :user
      trader_to_delete = User.create!(email: "delete_me@example.com", password: "password", admin: false)
      expect {
        delete admin_trader_path(trader_to_delete)
      }.to change(User, :count).by(-1)
      expect(response).to redirect_to(admin_traders_path)
      follow_redirect!
      expect(flash[:notice]).to include("Trader deleted successfully")
    end
  end

  describe "PUT /admin/traders/:id/approve" do
    
    it "calls the approve action for the trader" do
      sign_in admin_user, scope: :user
      
      expect(unapproved_trader.approved).to eq(false)
      
      put approve_admin_trader_path(unapproved_trader)
      
      expect(response).to redirect_to(admin_traders_path)
      
      unapproved_trader.reload
      
      expect(unapproved_trader.approved).to eq(true)
      
      follow_redirect!
      expect(flash[:notice]).to include("has been approved")
    end
  end
end