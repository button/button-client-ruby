require 'button/resources/orders'
require 'button/errors'

NO_API_KEY_MESSAGE = 'Must provide a Button API key.  Find yours at '\
  'https://app.usebutton.com/settings/organization'

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
    def initialize(api_key)
      if api_key.nil? || api_key.empty?
        raise ButtonClientError, NO_API_KEY_MESSAGE
      end

      @orders = Orders.new(api_key)
    end

    attr_reader :orders
  end
end
