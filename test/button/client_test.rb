require File.expand_path('../../test_helper', __FILE__)

class ClientTest < Test::Unit::TestCase
  def test_requires_api_key
    assert_raise(ArgumentError) do
      Button::Client.new
    end

    assert_raise(Button::ButtonClientError) do
      Button::Client.new(nil)
    end

    assert_raise(Button::ButtonClientError) do
      Button::Client.new('')
    end
  end

  def test_exposes_orders
    client = Button::Client.new('sk-XXX')
    assert_respond_to(client, :orders)
  end
end
