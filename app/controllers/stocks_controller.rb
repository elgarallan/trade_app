class StocksController < ApplicationController
    def index
      @stocks = current_user.stocks
      @stock_prices = fetch_latest_stock_prices(@stocks.map(&:symbol).uniq)
    end

    private

    def fetch_latest_stock_prices(symbols)
      prices = {}

      symbols.each do |symbol|
        cache_key = "stock_price:#{symbol}"
        cached_price = Rails.cache.read(cache_key)

        if cached_price
          prices[symbol] = cached_price
          next
        end

        response = AvaApi.fetch_records(symbol)

        if response["Error Message"] || response["Note"]
          Rails.logger.warn "API error for #{symbol}: #{response['Error Message'] || response['Note']}"
          prices[symbol] = nil
          next
        end

        time_series = response["Time Series (5min)"]
        if time_series && time_series.any?
          latest = time_series.values.first
          price = latest["1. open"]

          if price
            price = price.to_f
            Rails.cache.write(cache_key, price, expires_in: 5.minutes)
            prices[symbol] = price
          else
            Rails.logger.warn "Price missing in latest data for #{symbol}"
            prices[symbol] = nil
          end
        else
          Rails.logger.warn "Time series data unavailable for #{symbol}. Response: #{response.inspect}"
          prices[symbol] = nil
        end

        sleep(12)
      end

      prices
    end
end
