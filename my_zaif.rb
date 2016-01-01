require './market.rb'
require 'Zaif'

class MyZaif < Market
# Zaif wapper class

  # @param [String] @address the address of Zaif Wallet
  # The address cannot be get with Zaif API.
  # This should be set with Environment Variable.
  # @param [String] @currency_code
  # @param [Zaif::API] @client
  def initialize()
    @name = "Zaif"
    @api_key = ENV["ZAIF_API_KEY"]
    @api_key_secret = ENV["ZAIF_API_KEY_SECRET"]
    @address = ENV["ZAIF_ADDRESS"]
    opts = {
      "api_key":@api_key,
      "api_secret":@api_key_secret
    }
    @currency_code = "btc"
    @client = Zaif::API.new(opts)
    update()
  end

  def update()
    t = @client.get_ticker(@currency_code)
    @ask = t["ask"].to_f
    @bid = t["bid"].to_f
    b = @client.get_info()
    @left_jpy = b["funds"]["jpy"].to_f
    @left_btc = b["funds"]["btc"].to_f
  end

  def buy(rate,amount=0)
  end

  def sell(rate,amount=0)
  end

  def market_buy(amount=0)

  end

  def market_sell(amount=0)

  end

  def send(amount, address)
    @client.withdraw(@currency_code, address, amount)
  end
end