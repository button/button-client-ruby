require File.expand_path('../../../test_helper', __FILE__)

class CustomersTest < Test::Unit::TestCase
  def setup
    @customers = Button::Customers.new(
      'sk-XXX',
      secure: true,
      timeout: nil,
      hostname: 'api.usebutton.com',
      port: 443
    )

    @headers = {
      'Authorization' => 'Basic c2stWFhYOg==',
      'User-Agent' => Button::Resource::USER_AGENT
    }
  end

  def teardown
    WebMock.reset!
  end

  def test_create
    stub_request(:post, 'https://api.usebutton.com/v1/customers')
      .with(body: '{"id":"1234"}', headers: @headers)
      .to_return(status: 200, body: '{ "meta": { "status": "ok" }, "object": { "id": "1234" } }')

    response = @customers.create(id: '1234')
    assert_equal(response.data[:id], '1234')
  end
end
