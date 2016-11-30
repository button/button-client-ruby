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

  def test_sets_default_config_parameters
    client = Button::Client.new('sk-XXX')
    assert_equal(client.orders.config, {
      hostname: 'api.usebutton.com',
      port: 443,
      secure: true,
      timeout: nil
    })
  end

  def test_allows_config_overrides
    config = {
      hostname: 'localhost',
      port: 8080,
      secure: false,
      timeout: 20
    }

    client = Button::Client.new('sk-XXX', config)
    assert_equal(client.orders.config, config)
  end

  def test_sets_default_port_properly
    client = Button::Client.new('sk-XXX', secure: false)
    assert_equal(client.orders.config[:port], 80)
  end
end
