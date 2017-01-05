require File.expand_path('../../../test_helper', __FILE__)

class Accounts < Test::Unit::TestCase
  def setup
    @accounts = Button::Accounts.new(
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
    stub_request(:get, 'https://api.usebutton.com/v1/affiliation/accounts')
      .with(headers: @headers)
      .to_return(status: 200, body: '{ "meta": { "status": "ok" }, "objects": [{ "a": 1 }] }')

    response = @accounts.all
    assert_equal(response.data.size, 1)
    assert_equal(response.data[0][:a], 1)
  end

  def test_transactions
    body = '{ "meta": { "status": "ok", "prev": "https://bloop.net?cursor=1989",'\
           ' "next": "https://bloop.net?cursor=1991" }, "objects": [{ "a": 1 }] }'
    stub_request(:get, 'https://api.usebutton.com/v1/affiliation/accounts/acc-1/transactions')
      .with(headers: @headers)
      .to_return(status: 200, body: body)

    response = @accounts.transactions('acc-1')
    assert_equal(response.data.size, 1)
    assert_equal(response.data[0][:a], 1)
    assert_equal(response.prev_cursor, '1989')
    assert_equal(response.next_cursor, '1991')
  end

  def test_transactions_with_cursor
    body = '{ "meta": { "status": "ok", "prev": "https://bloop.net?cursor=1989",'\
           ' "next": "https://bloop.net?cursor=1991" }, "objects": [{ "a": 1 }] }'
    stub_request(:get, 'https://api.usebutton.com/v1/affiliation/accounts/acc-1/transactions?cursor=1989')
      .with(headers: @headers)
      .to_return(status: 200, body: body)

    response = @accounts.transactions('acc-1', cursor: '1989')
    assert_equal(response.data.size, 1)
    assert_equal(response.data[0][:a], 1)
  end

  def test_transactions_with_start_and_end
    body = '{ "meta": { "status": "ok", "prev": "https://bloop.net?cursor=1989",'\
           ' "next": "https://bloop.net?cursor=1991" }, "objects": [{ "a": 1 }] }'
    stub_request(:get, 'https://api.usebutton.com/v1/affiliation/accounts/acc-1/transactions?end=2014-01-01&start=2012-01-01')
      .with(headers: @headers)
      .to_return(status: 200, body: body)

    response = @accounts.transactions('acc-1', start: '2012-01-01', end: '2014-01-01')
    assert_equal(response.data.size, 1)
    assert_equal(response.data[0][:a], 1)
  end
end
