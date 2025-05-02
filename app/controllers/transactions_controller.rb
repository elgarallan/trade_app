class TransactionsController < ApplicationController
  before_action :authenticate_user!

    def index
      @transactions = current_user.transactions.order(created_at: :desc)
    end

    def new
      @transaction = current_user.transactions.new
    end

    def create
      @transaction = current_user.transactions.new(transaction_params_from_quote)

      if @transaction.save
        update_stock_on_transaction(@transaction)
        redirect_to transactions_path, notice: "Transaction was successfully placed."
      else
        @stock_data = { symbol: params[:symbol], price: params[:price] }
        render :stock_quote_display_view, status: :unprocessable_entity
      end
    end

    private

    def transaction_params
      params.require(:transaction).permit(:symbol, :transaction_type, :shares, :price)
    end

    def transaction_params_from_quote
      params.permit(:symbol, :transaction_type, :shares, :price).merge(user: current_user)
    end

    def update_stock_on_transaction(transaction)
      stock = current_user.stocks.find_or_create_by(symbol: transaction.symbol)

      quantity_change = transaction.shares
      cash_change = transaction.shares * transaction.price

      if transaction.transaction_type == "sell"
        quantity_change *= -1
        current_user.cash_balance += cash_change
      else
        current_user.cash_balance -= cash_change
      end

      stock.shares ||= 0
      stock.shares += quantity_change

      stock.save
      current_user.save
    end
end
