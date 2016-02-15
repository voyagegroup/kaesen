require_relative 'market.rb'
require 'net/http'
require 'openssl'
require 'json'

module Bot

  # Coincheck Wrapper Class
  # https://coincheck.jp/documents/exchange/api?locale=ja
  class Coincheck < Market

    def initialize()
      super()
      @name        = "Coincheck"
      @api_key     = ENV["COINCHECK_KEY"]
      @api_secret  = ENV["COINCHECK_SECRET"]
      @url_public  = "https://coincheck.jp"
      @url_private = @url_public
    end

    #############################################################
    # API for public information
    #############################################################

    # Get ticker information.
    # @return [hash] ticker       
    #   ask: [N] 最良売気配値
    #   bid: [N] 最良買気配値
    #   last: [N] 最近値(?用語要チェック), last price
    #   high: [N] 高値    
    #   low: [N] 安値     
    #   timestamp: [nil]
    #   ltimestamp: [int] ローカルタイムスタンプ
    #   volume: [N] 取引量
    def ticker
      h = get_ssl(@url_public + "/api/ticker")
      {
        "ask"    => N.new(h["ask"]),
        "bid"    => N.new(h["bid"]),
        "last"   => N.new(h["last"]),
        "high"   => N.new(h["high"]),
        "low"    => N.new(h["low"]),
        "timestamp" => h["timestamp"],
        "ltimestamp" => Time.now.to_i,
        "volume" => N.new(h["volume"]), # h["volume"] は String
      }
    end

    # Connect to address via https, and return json reponse.
    def get_ssl(address)
      uri = URI.parse(address)
      begin
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true
        https.open_timeout = 5
        https.read_timeout = 15
        https.verify_mode = OpenSSL::SSL::VERIFY_PEER
        https.verify_depth = 5

        https.start {|w|
          response = w.get(uri.request_uri)
          case response
            when Net::HTTPSuccess
              json = JSON.parse(response.body)
              raise JSONException, response.body if json == nil
              return json
            else
              raise ConnectionFailedException, "Failed to connect to #{@name}."
          end
        }
      rescue
        raise
      end
    end

  end
end
