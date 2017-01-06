require 'cgi'
require 'uri'

module Button
  # Response is a simple proxy class for easy value unpacking from an API
  # response.  It is constructed with a hash and proxies method calls on the
  # instance down to keys in the underling hash.
  #
  # ## Usage
  #
  # response = Button::Response.new({
  #   prev: 'https://bloop.net/?cursor=1989',
  #   next: 'https://bloop.net/?cursor=1991'
  # }, :a => 1, :b => "two")
  #
  # puts response.data
  # puts response.next_cursor
  # puts response.prev_cursor
  #
  class Response
    def initialize(meta, response_data)
      @meta = meta
      @response_data = response_data
    end

    def to_s
      repr = ''

      if @response_data.is_a?(Hash)
        repr = @response_data.reduce([]) do |acc, (name, value)|
          acc + ["#{name}: #{value || 'nil'}"]
        end.join(', ')
      elsif @response_data.is_a?(Array)
        repr = "#{@response_data.size} elements"
      end

      "Button::Response(#{repr})"
    end

    def data
      @response_data
    end

    def next_cursor
      Response.format_cursor(@meta.fetch(:next, nil))
    end

    def prev_cursor
      Response.format_cursor(@meta.fetch(:prev, nil))
    end

    class << self
      def format_cursor(cursor_url)
        return nil unless cursor_url

        parsed = URI(cursor_url)
        return nil unless parsed.query

        query = CGI.parse(parsed.query)
        cursor = query.fetch('cursor', [])

        cursor.empty? ? nil : cursor[0]
      end
    end
  end
end
