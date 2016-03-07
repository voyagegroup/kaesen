module Kaesen
  class Client
    attr_reader :ticker
    attr_reader :balance
    attr_reader :depth

    def initialize
      @markets = []   # [Array]
                      #   [Market] instance of markets
      @ticker = []    # [Array]
                      #   [Hash]: hash of ticker
      @depth = []     # [Array]
                      #   [Hash]: hash of depth
      @balance = []   # [Array]
                      #   [Hash]: hash of balance
    end

    # register the instance of market
    # @parm [Market]
    def add(market)
      @markets.add(market)
    end

    # Update market information.
    # @return [hash] hash of ticker
    def update_ticker()
      @ticker = []
      @markets.each{|m|
        @ticker.add(m.ticker)
      }
      @ticker
    end

    # Update market information.
    # @return [hash] hash of depth
    def update_depth()
      @depth = []
      @markets.each{|m|
        @depth.add(m.depth)
      }
      @depth
    end

    # Update asset information.
    # @return [hash] hash of balance
    def update_balance()
      @balance = []
      @markets.each{|m|
        @balance.add(m.balance)
      }
      @balance
    end
  end
end
