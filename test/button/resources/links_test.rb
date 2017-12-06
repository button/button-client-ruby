require File.expand_path('../../../test_helper', __FILE__)

class LinksTest < Test::Unit::TestCase
  def setup
    @links = Button::Links.new(
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
    stub_request(:post, 'https://api.usebutton.com/v1/links')
      .with(body: '{"a":1}', headers: @headers)
      .to_return(status: 200, body: '{ "meta": { "status": "ok" }, "object": { "a": 1 } }')

    response = @links.create(a: 1)
    assert_equal(response.data[:a], 1)
  end

  def test_get_info
    stub_request(:post, 'https://api.usebutton.com/v1/links/info')
      .with(body: '{"a":1}', headers: @headers)
      .to_return(status: 200, body: '{ "meta": { "status": "ok" }, "object": { "a": 1 } }')

    response = @links.get_info(a: 1)
    assert_equal(response.data[:a], 1)
  end
end
