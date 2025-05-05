class Admin::TradersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_trader, only: [ :show, :edit, :update, :destroy, :approve ]

  # Index action to list all non-admin users (traders)
  def index
    @traders = User.where(admin: false)
  end

  # New action for rendering the 'new' trader form
  def new
    @trader = User.new
  end

  # Create action to save the new trader
  def create
    @trader = User.new(trader_params)
    if @trader.save
      redirect_to admin_traders_path, notice: "Trader created successfully."
    else
      render :new
    end
  end

  # Edit action to render the 'edit' trader form
  def edit
    # @trader is already set by the before_action
  end

  def destroy
    @trader = User.find(params[:id])
    if @trader.destroy
      redirect_to admin_traders_path, notice: "Trader deleted successfully."
    else
      redirect_to admin_traders_path, alert: "Failed to delete trader."
    end
  end

  def show
    @trader = User.find(params[:id])
    @transactions = @trader.transactions.order(created_at: :desc)
    @stocks = @trader.stocks
  end

  # Update action to update the existing trader
  def update
    if @trader.update(trader_params)
      redirect_to admin_traders_path, notice: "Trader updated successfully."
    else
      render :edit
    end
  end

  def approve
    if @trader.update(approved: true)
      UserMailer.approval_email(@trader).deliver_now
      redirect_to admin_traders_path, notice: "#{@trader.email} has been approved."
    else
      redirect_to admin_traders_path, alert: "Failed to approve trader."
    end
  end

  private

  # Find the trader by ID for edit and update actions
  def set_trader
    @trader = User.find(params[:id])
  end

  # Strong parameters to permit email and password attributes
  def trader_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
