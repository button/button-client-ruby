require File.expand_path('../../../test_helper', __FILE__)

class OrdersTest < Test::Unit::TestCase
  def setup
    @orders = Button::Orders.new('sk-XXX', {
      secure: true,
      timeout: nil,
      hostname: 'api.usebutton.com',
      port: 443
    })

    @headers = {
      'Authorization' => 'Basic c2stWFhYOg==',
      'User-Agent' => Button::Resource::USER_AGENT
    }
  end

  def teardown
    WebMock.reset!
  end

  def test_get
    stub_request(:get, 'https://api.usebutton.com/v1/order/btnorder-XXX')
      .with(headers: @headers)
      .to_return(status: 200, body: '{ "meta": { "status": "ok" }, "object": { "a": 1 } }')

    response = @orders.get('btnorder-XXX')
    assert_equal(response.a, 1)
  end

  def test_create
    stub_request(:post, 'https://api.usebutton.com/v1/order')
      .with(body: '{"a":1}', headers: @headers)
      .to_return(status: 200, body: '{ "meta": { "status": "ok" }, "object": { "a": 1 } }')

    response = @orders.create(a: 1)
    assert_equal(response.a, 1)
  end

  def test_update
    stub_request(:post, 'https://api.usebutton.com/v1/order/btnorder-XXX')
      .with(body: '{"a":1}', headers: @headers)
      .to_return(status: 200, body: '{ "meta": { "status": "ok" }, "object": { "a": 1 } }')

    response = @orders.update('btnorder-XXX', a: 1)
    assert_equal(response.a, 1)
  end

  def test_delete
    stub_request(:delete, 'https://api.usebutton.com/v1/order/btnorder-XXX')
      .with(headers: @headers)
      .to_return(status: 200, body: '{ "meta": { "status": "ok" }, "object": null }')

    response = @orders.delete('btnorder-XXX')
    assert_equal(response.to_hash, {})
  end
end
