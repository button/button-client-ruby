require File.expand_path('../../test_helper', __FILE__)

class ResponseTest < Test::Unit::TestCase
  def test_meta
    meta = {
      prev: 'https://bloop.net/dork?bleep&cursor=1989',
      next: 'https://bloop.net/dork?bleep&cursor=1991'
    }

    response = Button::Response.new(meta, {})
    assert_equal(response.prev_cursor, '1989')
    assert_equal(response.next_cursor, '1991')
  end

  def test_data
    data = { a: 1, b: 'two' }
    response = Button::Response.new({}, data)
    assert_equal(response.data, a: 1, b: 'two')
  end

  def test_to_s
    assert_equal(
      Button::Response.new({}, a: 1, b: 'two').to_s,
      'Button::Response(a: 1, b: two)'
    )

    assert_equal(
      Button::Response.new({}, a: 1, b: nil).to_s,
      'Button::Response(a: 1, b: nil)'
    )

    assert_equal(
      Button::Response.new({}, {}).to_s,
      'Button::Response()'
    )

    assert_equal(
      Button::Response.new({}, [1, 2, 3]).to_s,
      'Button::Response(3 elements)'
    )

    assert_equal(
      Button::Response.new({}, []).to_s,
      'Button::Response(0 elements)'
    )
  end

  def test_cursor_parsing
    assert_equal(Button::Response.format_cursor('bloop'), nil)
    assert_equal(Button::Response.format_cursor('bloop.net'), nil)
    assert_equal(Button::Response.format_cursor('https://bloop.net'), nil)
    assert_equal(Button::Response.format_cursor('////'), nil)
    assert_equal(Button::Response.format_cursor('https://bloop.net/bleep?two=three'), nil)
    assert_equal(Button::Response.format_cursor('https://bloop.net/bleep?two=three&cursor=pup'), 'pup')
  end
end
