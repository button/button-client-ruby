require File.expand_path('../../../test_helper', __FILE__)

class ResourceTest < Test::Unit::TestCase
  def setup
    @resource = Button::Resource.new(
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

  def test_raises_with_empty_response
    stub_request(:get, 'https://api.usebutton.com/v1/bloop')
      .with(headers: @headers)
      .to_return(status: 200, body: '')

    assert_raises(Button::ButtonClientError) do
      @resource.api_get('/v1/bloop')
    end
  end

  def test_raises_with_nil_response
    stub_request(:get, 'https://api.usebutton.com/v1/bloop')
      .with(headers: @headers)
      .to_return(status: 200, body: nil)

    assert_raises(Button::ButtonClientError) do
      @resource.api_get('/v1/bloop')
    end
  end

  def test_raises_with_invalid_json_response
    stub_request(:get, 'https://api.usebutton.com/v1/bloop')
      .with(headers: @headers)
      .to_return(status: 200, body: 'invalid json')

    assert_raises(Button::ButtonClientError) do
      @resource.api_get('/v1/bloop')
    end
  end

  def test_raises_with_a_server_error
    stub_request(:get, 'https://api.usebutton.com/v1/bloop')
      .with(headers: @headers)
      .to_return(status: 404, body: '{ "meta": { "status": "error" }, "error": { "message": "bloop" } }')

    assert_raises(Button::ButtonClientError.new('bloop')) do
      @resource.api_get('/v1/bloop')
    end
  end

  def test_raises_with_an_unknown_status_error
    stub_request(:get, 'https://api.usebutton.com/v1/bloop')
      .with(headers: @headers)
      .to_return(status: 404, body: '{ "meta": { "status": "wat" }, "error": { "message": "bloop" } }')

    assert_raises(Button::ButtonClientError.new('Unknown status: wat')) do
      @resource.api_get('/v1/bloop')
    end
  end

  def test_raises_if_receives_unknown_error_response
    stub_request(:get, 'https://api.usebutton.com/v1/bloop')
      .with(headers: @headers)
      .to_return(status: 404, body: '{}')

    assert_raises(Button::ButtonClientError) do
      @resource.api_get('/v1/bloop')
    end

    WebMock.reset!

    stub_request(:get, 'https://api.usebutton.com/v1/bloop')
      .with(headers: @headers)
      .to_return(status: 404, body: '{ "meta": "wat" }')

    assert_raises(Button::ButtonClientError) do
      @resource.api_get('/v1/bloop')
    end

    WebMock.reset!

    stub_request(:get, 'https://api.usebutton.com/v1/bloop')
      .with(headers: @headers)
      .to_return(status: 404, body: '{ "meta": { "status": "error" }, "error": "wat" }')

    assert_raises(Button::ButtonClientError) do
      @resource.api_get('/v1/bloop')
    end

    WebMock.reset!
  end

  def test_gets_a_resource
    stub_request(:get, 'https://api.usebutton.com/v1/bloop')
      .with(headers: @headers)
      .to_return(status: 200, body: '{ "meta": { "status": "ok" }, "object": { "a": 1 } }')

    response = @resource.api_get('/v1/bloop')
    assert_equal(response.data[:a], 1)
  end

  def test_gets_a_resource_at_an_api_version
    resource = Button::Resource.new(
      'sk-XXX',
      secure: true,
      timeout: nil,
      hostname: 'api.usebutton.com',
      port: 443,
      api_version: '2017-01-01'
    )

    headers = {
      'Authorization' => 'Basic c2stWFhYOg==',
      'User-Agent' => Button::Resource::USER_AGENT,
      'X-Button-API-Version' => '2017-01-01'
    }

    stub_request(:get, 'https://api.usebutton.com/v1/bloop')
      .with(headers: headers)
      .to_return(status: 200, body: '{ "meta": { "status": "ok" }, "object": { "a": 1 } }')

    response = resource.api_get('/v1/bloop')
    assert_equal(response.data[:a], 1)
  end

  def test_gets_a_resource_with_query
    stub_request(:get, 'https://api.usebutton.com/v1/bloop?a=1&b=bloop')
      .with(headers: @headers)
      .to_return(status: 200, body: '{ "meta": { "status": "ok" }, "object": { "a": 1 } }')

    response = @resource.api_get('/v1/bloop', 'a' => 1, 'b' => 'bloop')
    assert_equal(response.data[:a], 1)
  end

  def test_posts_a_resource
    stub_request(:post, 'https://api.usebutton.com/v1/bloop')
      .with(headers: @headers)
      .with(body: '{"a":1}')
      .to_return(status: 200, body: '{ "meta": { "status": "ok" }, "object": { "a": 1 } }')

    response = @resource.api_post('/v1/bloop', a: 1)
    assert_equal(response.data[:a], 1)
  end

  def test_deletes_a_resource
    stub_request(:delete, 'https://api.usebutton.com/v1/bloop/1')
      .with(headers: @headers)
      .to_return(status: 200, body: '{ "meta": { "status": "ok" }, "object": null }')

    response = @resource.api_delete('/v1/bloop/1')
    assert_equal(response.data, nil)
  end

  def test_uses_config
    stub_request(:get, 'http://localhost:8080/v1/bloop')
      .with(headers: @headers)
      .to_return(status: 200, body: '{ "meta": { "status": "ok" }, "object": { "a": 1 } }')

    resource = Button::Resource.new(
      'sk-XXX',
      secure: false,
      timeout: 1989,
      hostname: 'localhost',
      port: 8080
    )

    response = resource.api_get('/v1/bloop')
    assert_equal(resource.timeout, 1989)
    assert_equal(response.data[:a], 1)
  end
end
