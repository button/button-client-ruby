require File.expand_path('../../../test_helper', __FILE__)

class OffersTest < Test::Unit::TestCase
  def setup
    @offers = Button::Offers.new(
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

  def test_get
    stub_request(:post, 'https://api.usebutton.com/v1/offers')
      .with(body: '{"a":1}', headers: @headers)
      .to_return(status: 200, body: '{ "meta": { "status": "ok" }, "object": { "a": 1 } }')

    response = @offers.get(a: 1)
    assert_equal(response.data[:a], 1)
  end
end
