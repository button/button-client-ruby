require File.expand_path('../../../test_helper', __FILE__)

class OrdersTest < Test::Unit::TestCase
  def teardown
    WebMock.reset!
  end

  def test_get
    stub_request(:get, 'https://api.usebutton.com/v1/order/btnorder-XXX')
      .with(:headers => { 'Authorization' => 'Basic c2stWFhYOg==' })
      .to_return(:status => 200, :body => '{ "meta": { "status": "ok" }, "object": { "a": 1 } }')

    response = Button::Orders.new('sk-XXX').get('btnorder-XXX')
    assert_equal(response.a, 1)
  end

  def test_create
    stub_request(:post, 'https://api.usebutton.com/v1/order')
      .with(:body => '{"a":1}', :headers => { 'Authorization' => 'Basic c2stWFhYOg==' })
      .to_return(:status => 200, :body => '{ "meta": { "status": "ok" }, "object": { "a": 1 } }')

    response = Button::Orders.new('sk-XXX').create(a: 1)
    assert_equal(response.a, 1)
  end

  def test_update
    stub_request(:post, 'https://api.usebutton.com/v1/order/btnorder-XXX')
      .with(:body => '{"a":1}', :headers => { 'Authorization' => 'Basic c2stWFhYOg==' })
      .to_return(:status => 200, :body => '{ "meta": { "status": "ok" }, "object": { "a": 1 } }')

    response = Button::Orders.new('sk-XXX').update('btnorder-XXX', a: 1)
    assert_equal(response.a, 1)
  end

  def test_delete
    stub_request(:delete, 'https://api.usebutton.com/v1/order/btnorder-XXX')
      .with(:headers => { 'Authorization' => 'Basic c2stWFhYOg==' })
      .to_return(:status => 200, :body => '{ "meta": { "status": "ok" }, "object": null }')

    response = Button::Orders.new('sk-XXX').delete('btnorder-XXX')
    assert_equal(response.to_hash, {})
  end
end
