class Admin::TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def index
    @transactions = Transaction.includes(:user).order(created_at: :desc)
  end

  def show
    @transaction = Transaction.find(params[:id])
  end

  private

  def require_admin
    redirect_to root_path, alert: "Access denied." unless current_user.admin?
  end
end
