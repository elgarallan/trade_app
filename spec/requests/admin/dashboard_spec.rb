require 'rails_helper'

RSpec.describe "Admin::Dashboard", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:admin_user) { User.create!(email: "admin@example.com", password: "password", admin: true, approved: true, cash_balance: 10_000) }
  let(:regular_user) { User.create!(email: "user@example.com", password: "password", admin: false, approved: true, cash_balance: 10_000) }

  describe "GET /admin/dashboard" do
    it "allows access and renders the dashboard for admin" do
      sign_in admin_user, scope: :user
      get "/admin/dashboard"
      expect(response).to have_http_status(:ok)
    end

    it "redirects non-admin with access denied message" do
      sign_in regular_user, scope: :user
      get "/admin/dashboard"
      expect(response).to have_http_status(:redirect)
      follow_redirect!
      expect(flash[:alert]).to include("Access denied")
    end
  end
end