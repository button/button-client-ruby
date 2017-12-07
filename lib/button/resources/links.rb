require 'button/resources/resource'

module Button
  # https://www.usebutton.com/developers/api-reference/
  #
  class Links < Resource
    def path
      '/v1/links'
    end

    # Create a Link
    #
    # @param [Hash] link the link to create
    # @return [Button::Response] the API response
    #
    def create(link)
      api_post(path, link)
    end

    # Get information for Link
    #
    # @param [Hash] link the link to get information on
    # @return [Button::Response] the API response
    #
    def get_info(link)
      api_post(path + '/info', link)
    end
  end
end
