module Button
  # Response is a simple proxy class for easy value unpacking from an API
  # response.  It is constructed with a hash and proxies method calls on the
  # instance down to keys in the underling hash.
  #
  # ## Usage
  #
  # response = Button::Response.new({ :a => 1, :b => "two" })
  # puts response.a
  # puts response.to_hash
  #
  class Response
    def initialize(attrs)
      @attrs = attrs || {}
    end

    def to_s
      values = @attrs.reduce([]) do |acc, (name, value)|
        acc + ["#{name}: #{value || 'nil'}"]
      end.join(', ')

      "Button::Response(#{values})"
    end

    def to_hash
      @attrs
    end

    def method_missing(attr)
      @attrs[attr] || super
    end

    def respond_to_missing?(method_name, include_private = false)
      @attrs.key?(method_name) || super
    end
  end
end
