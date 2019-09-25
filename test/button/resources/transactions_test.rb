require File.expand_path('../../../test_helper', __FILE__)

class Transactions < Test::Unit::TestCase
  def setup
    @transactions = Button::Transactions.new(
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
    body = '{ "meta": { "status": "ok", "prev": "https://bloop.net?cursor=1989",'\
           ' "next": "https://bloop.net?cursor=1991" }, "objects": [{ "a": 1 }] }'
    stub_request(:get, 'https://api.usebutton.com/v1/affiliation/transactions')
      .with(headers: @headers)
      .to_return(status: 200, body: body)

    response = @transactions.all
    assert_equal(response.data.size, 1)
    assert_equal(response.data[0][:a], 1)
    assert_equal(response.prev_cursor, '1989')
    assert_equal(response.next_cursor, '1991')
  end

  def test_all_with_cursor
    body = '{ "meta": { "status": "ok", "prev": "https://bloop.net?cursor=1989",'\
           ' "next": "https://bloop.net?cursor=1991" }, "objects": [{ "a": 1 }] }'
    stub_request(:get, 'https://api.usebutton.com/v1/affiliation/transactions?cursor=1989')
      .with(headers: @headers)
      .to_return(status: 200, body: body)

    response = @transactions.all(cursor: '1989')
    assert_equal(response.data.size, 1)
    assert_equal(response.data[0][:a], 1)
  end

  def test_transactions_with_start_end_and_time_field
    body = '{ "meta": { "status": "ok", "prev": "https://bloop.net?cursor=1989",'\
           ' "next": "https://bloop.net?cursor=1991" }, "objects": [{ "a": 1 }] }'
    stub_request(:get, 'https://api.usebutton.com/v1/affiliation/transactions?end=2014-01-01&start=2012-01-01&time_field=modified_date')
      .with(headers: @headers)
      .to_return(status: 200, body: body)

    response = @transactions.all(start: '2012-01-01', end: '2014-01-01',
                                 time_field: Button::Constants::TIME_FIELD_MODIFIED)
    assert_equal(response.data.size, 1)
    assert_equal(response.data[0][:a], 1)
  end
end
