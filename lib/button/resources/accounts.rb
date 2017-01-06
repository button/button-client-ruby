require 'button/resources/resource'

module Button
  # https://www.usebutton.com/developers/api-reference/
  #
  class Accounts < Resource
    def path(account_id = nil)
      return "/v1/affiliation/accounts/#{account_id}/transactions" if account_id
      '/v1/affiliation/accounts'
    end

    # Gets a list of available accounts
    #
    # @return [Button::Response] the API response
    #
    def all
      api_get(path)
    end

    # Gets a list of transactions for an account
    #
    # @param [String] account_id the account id to look up transactions for
    # @option [String] cursor the account id to look up transactions for
    # @option [ISO-8601 datetime String] start The start date to filter
    #   transactions
    # @option [ISO-8601 datetime String] end The end date to filter
    #   transactions
    # @return [Button::Response] the API response
    #
    def transactions(account_id, opts = {})
      query = {}
      query['cursor'] = opts[:cursor] if opts[:cursor]
      query['start'] = opts[:start] if opts[:start]
      query['end'] = opts[:end] if opts[:end]

      api_get(path(account_id), query)
    end
  end
end
