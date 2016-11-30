require File.expand_path('../../../test_helper', __FILE__)

class ResourceTest < Test::Unit::TestCase
  def teardown
    WebMock.reset!
  end

  def test_raises_with_empty_response
    stub_request(:get, 'https://api.usebutton.com/v1/bloop')
      .to_return(status: 200, body: '')

    assert_raises(Button::ButtonClientError) do
      Button::Resource.new('sk-XXX').api_get('/v1/bloop')
    end
  end

  def test_raises_with_nil_response
    stub_request(:get, 'https://api.usebutton.com/v1/bloop')
      .to_return(status: 200, body: nil)

    assert_raises(Button::ButtonClientError) do
      Button::Resource.new('sk-XXX').api_get('/v1/bloop')
    end
  end

  def test_raises_with_invalid_json_response
    stub_request(:get, 'https://api.usebutton.com/v1/bloop')
      .to_return(status: 200, body: 'invalid json')

    assert_raises(Button::ButtonClientError) do
      Button::Resource.new('sk-XXX').api_get('/v1/bloop')
    end
  end

  def test_raises_with_a_server_error
    stub_request(:get, 'https://api.usebutton.com/v1/bloop')
      .to_return(status: 404, body: '{ "meta": { "status": "error" }, "error": { "message": "bloop" } }')

    assert_raises(Button::ButtonClientError.new('bloop')) do
      Button::Resource.new('sk-XXX').api_get('/v1/bloop')
    end
  end

  def test_raises_with_an_unknown_status_error
    stub_request(:get, 'https://api.usebutton.com/v1/bloop')
      .to_return(status: 404, body: '{ "meta": { "status": "wat" }, "error": { "message": "bloop" } }')

    assert_raises(Button::ButtonClientError.new('Unknown status: wat')) do
      Button::Resource.new('sk-XXX').api_get('/v1/bloop')
    end
  end

  def test_raises_if_receives_unknown_error_response
    stub_request(:get, 'https://api.usebutton.com/v1/bloop')
      .to_return(status: 404, body: '{}')

    assert_raises(Button::ButtonClientError) do
      Button::Resource.new('sk-XXX').api_get('/v1/bloop')
    end

    WebMock.reset!

    stub_request(:get, 'https://api.usebutton.com/v1/bloop')
      .to_return(status: 404, body: '{ "meta": "wat" }')

    assert_raises(Button::ButtonClientError) do
      Button::Resource.new('sk-XXX').api_get('/v1/bloop')
    end

    WebMock.reset!

    stub_request(:get, 'https://api.usebutton.com/v1/bloop')
      .to_return(status: 404, body: '{ "meta": { "status": "error" }, "error": "wat" }')

    assert_raises(Button::ButtonClientError) do
      Button::Resource.new('sk-XXX').api_get('/v1/bloop')
    end

    WebMock.reset!
  end

  def test_gets_a_resource
    stub_request(:get, 'https://api.usebutton.com/v1/bloop')
      .to_return(status: 200, body: '{ "meta": { "status": "ok" }, "object": { "a": 1 } }')

    response = Button::Resource.new('sk-XXX').api_get('/v1/bloop')
    assert_equal(response.a, 1)
  end

  def test_posts_a_resource
    stub_request(:post, 'https://api.usebutton.com/v1/bloop')
      .with(body: '{"a":1}')
      .to_return(status: 200, body: '{ "meta": { "status": "ok" }, "object": { "a": 1 } }')

    response = Button::Resource.new('sk-XXX').api_post('/v1/bloop', a: 1)
    assert_equal(response.a, 1)
  end

  def test_deletes_a_resource
    stub_request(:delete, 'https://api.usebutton.com/v1/bloop/1')
      .to_return(status: 200, body: '{ "meta": { "status": "ok" }, "object": null }')

    response = Button::Resource.new('sk-XXX').api_delete('/v1/bloop/1')
    assert_equal(response.to_hash, {})
  end
end
