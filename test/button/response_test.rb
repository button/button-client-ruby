require File.expand_path('../../test_helper', __FILE__)

class ResponseTest < Test::Unit::TestCase
  def test_method_lookups
    response = Button::Response.new(a: 1, b: 'two')
    assert_equal(response.a, 1)
    assert_equal(response.b, 'two')

    assert_raises(NoMethodError) do
      response.c
    end
  end

  def test_to_hash
    hash = { :a => 1, :b => 'two' }
    response = Button::Response.new(hash)
    assert_equal(response.to_hash, a: 1, b: 'two')
  end

  def test_to_s
    response = Button::Response.new(a: 1, b: 'two')
    assert_equal(response.to_s, 'Button::Response(a: 1, b: two)')
  end
end
