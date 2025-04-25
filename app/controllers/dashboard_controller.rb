class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
  end
  def show
    @stock_data = AvaApi.fetch_multiple_stocks
  end
end
