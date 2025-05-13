class Admin::TradersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_trader, only: [ :show, :edit, :update, :destroy, :approve ]
  
  def index
    @traders = User.where(admin: false)
  end
  
  def new
    @trader = User.new
  end
  
  def create
    @trader = User.new(trader_params)
    if @trader.save
      redirect_to admin_traders_path, notice: "Trader created successfully."
    else
      render :new
    end
  end
  
  def edit
   
  end
  def destroy
    @trader = User.find(params[:id])
    if @trader.stocks.exists? || @trader.transactions.exists?
      redirect_to admin_traders_path, alert: "Cannot delete trader with associated stocks or transactions."
    else
      @trader.destroy
      redirect_to admin_traders_path, notice: "Trader deleted successfully."
    end
  end
  def show
    @trader = User.find(params[:id])
    @stocks = @trader.stocks
    @transactions = @trader.transactions.order(created_at: :desc)
  end
  
 def update
  @trader = User.find(params[:id])
  if @trader.update(trader_params)
    redirect_to admin_traders_path, notice: 'Trader updated successfully.'
  else
    flash.now[:alert] = 'Update failed.'
    render :edit, status: :ok
  end
end

  def approve
    if @trader.update(approved: true)
      UserMailer.approval_email(@trader).deliver_later
      redirect_to admin_traders_path, notice: "#{@trader.email} has been approved."
    else
      redirect_to admin_traders_path, alert: "Failed to approve trader."
    end
  end
  private
  
  def set_trader
    @trader = User.find(params[:id])
  end
  
  def trader_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
