require "uri"
require "net/http"
require "json"

class AvaApi
  BASE_URL = "https://alpha-vantage.p.rapidapi.com/query"
  HEADERS = {
    "x-rapidapi-key" => ENV["API_KEY"],
    "x-rapidapi-host" => "alpha-vantage.p.rapidapi.com"
  }

  def self.fetch_multiple_stocks(symbols = %w[AAPL MSFT GOOGL AMZN META])
    results = {}

    symbols.each do |symbol|
      url = URI("#{BASE_URL}?function=TIME_SERIES_DAILY&symbol=#{symbol}&interval=5min&output_size=compact&datatype=json")

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(url, HEADERS)
      response = http.request(request)

      parsed = JSON.parse(response.body)
      results[symbol] = parsed
    end

    results
  end
end
