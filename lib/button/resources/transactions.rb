require 'button/resources/resource'

module Button
  # https://www.usebutton.com/developers/api-reference/
  #
  class Transactions < Resource
    # Gets a list of transactions
    #
    # @option [String] cursor the account id to look up transactions for
    # @option [ISO-8601 datetime String] start The start date to filter
    #   transactions
    # @option [ISO-8601 datetime String] end The end date to filter
    #   transactions
    # @option [String] time_field time field start and end filter on
    # @return [Button::Response] the API response
    #
    def all(opts = {})
      query = {}
      query['cursor'] = opts[:cursor] if opts[:cursor]
      query['start'] = opts[:start] if opts[:start]
      query['end'] = opts[:end] if opts[:end]
      query['time_field'] = opts[:time_field] if opts[:time_field]

      api_get('/v1/affiliation/transactions', query)
    end
  end
end
