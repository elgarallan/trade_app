class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!
  def index
    @traders = User.where(admin: false)
  end


  private

  def ensure_admin!
    redirect_to admin_dashboard_path, alert: "Access denied." unless current_user&.admin?
  end
end
