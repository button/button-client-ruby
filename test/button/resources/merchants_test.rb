require File.expand_path('../../../test_helper', __FILE__)

class Merchants < Test::Unit::TestCase
  def setup
    @merchants = Button::Merchants.new(
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

  def test_all
    stub_request(:get, 'https://api.usebutton.com/v1/merchants')
      .with(headers: @headers)
      .to_return(status: 200, body: '{ "meta": { "status": "ok" }, "objects": [{ "a": 1 }] }')

    response = @merchants.all
    assert_equal(response.data.size, 1)
    assert_equal(response.data[0][:a], 1)
  end

  def test_all_with_query
    body = '{ "meta": { "status": "ok" }, "objects": [{ "a": 1 }] }'
    stub_request(:get, 'https://api.usebutton.com/v1/merchants?currency=GBP&status=pending')
      .with(headers: @headers)
      .to_return(status: 200, body: body)

    response = @merchants.all(status: 'pending', currency: 'GBP')
    assert_equal(response.data.size, 1)
    assert_equal(response.data[0][:a], 1)
  end
end
