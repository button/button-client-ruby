require 'button/resources/resource'

module Button
  # https://www.usebutton.com/developers/api-reference/
  #
  class Customers < Resource
    def path(customer_id = nil)
      return "/v1/customers/#{customer_id}" if customer_id
      '/v1/customers'
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
