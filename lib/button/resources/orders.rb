require 'button/resources/resource'

module Button
  # https://www.usebutton.com/developers/api-reference/
  #
  class Orders < Resource
    def path(order_id = nil)
      return "/v1/order/#{order_id}" if order_id
      '/v1/order'
    end

    # Gets an order
    #
    # @param [String] order_id the order id
    # @return [Button::Response] the API response
    #
    def get(order_id)
      api_get(path(order_id))
    end

    # Creates an order
    #
    # @param [Hash] order the order to create
    # @return [Button::Response] the API response
    #
    def create(order)
      api_post(path, order)
    end

    # Updates an order
    #
    # @param [String] order_id the order id
    # @param [Hash] order the order to create
    # @return [Button::Response] the API response
    #
    def update(order_id, order)
      api_post(path(order_id), order)
    end

    # Deletes an order
    #
    # @param [String] order_id the order id
    # @return [Button::Response] the API response
    #
    def delete(order_id)
      api_delete(path(order_id))
    end
  end
end
