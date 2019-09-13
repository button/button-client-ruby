require 'button/resources/accounts'
require 'button/resources/customers'
require 'button/resources/links'
require 'button/resources/merchants'
require 'button/resources/offers'
require 'button/resources/orders'
require 'button/resources/transactions'
require 'button/errors'

NO_API_KEY_MESSAGE = 'Must provide a Button API key.  Find yours at '\
  'https://app.usebutton.com/settings/organization'.freeze

module Button
  # Client is the top-level interface for the Button API.  It exposes one
  # resource currently: `.orders`.  It requires a valid API key to make
  # requests on behalf of your organization, which can be found at
  # https://app.usebutton.com/settings/organization.
  #
  # ## Usage
  #
  # client = Button::Client.new("sk-XXX")
  # puts client.orders.get("btnorder-XXX")
  #
  class Client
    def initialize(api_key, config = {})
      if api_key.nil? || api_key.empty?
        raise ButtonClientError, NO_API_KEY_MESSAGE
      end

      config_with_defaults = merge_defaults(config)

      @accounts = Accounts.new(api_key, config_with_defaults)
      @customers = Customers.new(api_key, config_with_defaults)
      @links = Links.new(api_key, config_with_defaults)
      @merchants = Merchants.new(api_key, config_with_defaults)
      @offers = Offers.new(api_key, config_with_defaults)
      @orders = Orders.new(api_key, config_with_defaults)
      @tranasactions = Transactions.new(api_key, config_with_defaults)
    end

    def merge_defaults(config)
      secure = config.fetch(:secure, true)

      {
        secure: secure,
        timeout: config.fetch(:timeout, nil),
        hostname: config.fetch(:hostname, 'api.usebutton.com'),
        port: config.fetch(:port, secure ? 443 : 80),
        api_version: config.fetch(:api_version, nil)
      }
    end

    attr_reader :accounts, :customers, :merchants, :offers, :orders, :links, :transactions
    private :merge_defaults
  end
end
