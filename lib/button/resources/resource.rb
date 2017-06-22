require 'uri'
require 'net/http'
require 'json'

require 'button/errors'
require 'button/response'
require 'button/version'

module Button
  # Resource is a handy base class for making API requests.  It includes
  # serveral handy methods for making such requests:
  #
  # api_get(path)
  # api_post(path, body)
  # api_delete(path)
  #
  # ## Usage
  #
  # class Blorp < Button::Resource
  #
  #   def get(blorp_id)
  #     api_get("/api/v1/blorps/#{blorp_id}")
  #   end
  #
  # end
  #
  class Resource
    USER_AGENT = "Button/#{Button::VERSION} ruby/#{RUBY_VERSION}".freeze

    def initialize(api_key, config)
      @api_key = api_key
      @config = config
      @http = Net::HTTP.new(config[:hostname], config[:port])
      @http.use_ssl = config[:secure]

      return if config[:timeout].nil?
      @http.read_timeout = config[:timeout]
    end

    def timeout
      @http.read_timeout
    end

    # Performs an HTTP GET at the provided path.
    #
    # @param [String] path the HTTP path
    # @param [Hash=] query optional query params to send
    # @return [Button::Response] the API response
    #
    def api_get(path, query = nil)
      uri = URI(path)
      uri.query = URI.encode_www_form(query) if query
      api_request(Net::HTTP::Get.new(uri.to_s))
    end

    # Performs an HTTP POST at the provided path.
    #
    # @param [String] path the HTTP path
    # @param [Hash] body the HTTP request body
    # @return [Button::Response] the API response
    #
    def api_post(path, body)
      api_request(Net::HTTP::Post.new(path), body)
    end

    # Performs an HTTP DELETE at the provided path.
    #
    # @param [String] path the HTTP path
    # @return [Button::Response] the API response
    #
    def api_delete(path)
      api_request(Net::HTTP::Delete.new(path))
    end

    def api_request(request, body = nil)
      request.basic_auth(@api_key, '')
      request['User-Agent'] = USER_AGENT

      unless @config[:api_version].nil?
        request['X-Button-API-Version'] = @config[:api_version]
      end

      if !body.nil? && body.respond_to?(:to_json)
        request['Content-Type'] = 'application/json'
        request.body = body.to_json
      end

      body = @http.request(request).body
      process_response(body)
    end

    def process_response(response)
      if response.nil? || response.empty?
        raise ButtonClientError, 'Client received an empty response from the server'
      end

      begin
        parsed = JSON.parse(response, symbolize_names: true)
      rescue
        raise ButtonClientError, "Error parsing response as JSON: #{response}"
      end

      raise ButtonClientError, "Invalid response: #{parsed}" unless parsed[:meta].is_a?(Hash)

      meta = parsed[:meta]
      status = meta[:status]
      response_data = parsed.fetch(:object, parsed.fetch(:objects, {}))

      return Response.new(meta, response_data) if status == 'ok'
      raise ButtonClientError, "Unknown status: #{status}" unless status == 'error'
      raise ButtonClientError, parsed[:error][:message] if parsed[:error].is_a?(Hash)
      raise ButtonClientError, "Invalid response: #{parsed}"
    end

    attr_accessor :config
    private :api_request, :process_response
  end
end
