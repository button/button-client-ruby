require 'button/resources/resource'

module Button
  # https://www.usebutton.com/developers/api-reference/
  #
  class Merchants < Resource
    # Gets a list of available merchants
    #
    # @option [String] status The status to filter by. One of ('approved',
    #   'pending', or 'available')
    # @option [ISO-4217 String] currency Currency code to filter returned rates
    #   by
    # @return [Button::Response] the API response
    #
    def all(opts = {})
      query = {}
      query['status'] = opts[:status] if opts[:status]
      query['currency'] = opts[:currency] if opts[:currency]

      api_get('/v1/merchants', query)
    end
  end
end
