require 'button/resources/resource'

module Button
  # https://www.usebutton.com/developers/api-reference/
  #
  class Customers < Resource
    def path(customer_id = nil)
      return "/v1/customers/#{customer_id}" if customer_id
      '/v1/customers'
    end

    # Gets a customer
    #
    # @param [String] customer_id the customer id
    # @return [Button::Response] the API response
    #
    def get(customer_id)
      api_get(path(customer_id))
    end

    # Create a Customer
    #
    # @param [Hash] customer the customer to create
    # @return [Button::Response] the API response
    #
    def create(customer)
      api_post(path, customer)
    end
  end
end
