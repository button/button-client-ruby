require 'button/resources/resource'

module Button
  # https://www.usebutton.com/developers/api-reference/
  #
  class Offers < Resource
    def path
      '/v1/offers'
    end

    # Retrieve offers that are available to Publishers user
    #
    # @param [Hash] user to retrieve offers for
    # @return [Button::Response] the API response
    #
    def get_offers(user)
      api_post(path, user)
    end
  end
end
