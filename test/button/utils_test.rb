require File.expand_path('../../test_helper', __FILE__)

class UtilsTest < Test::Unit::TestCase
  def test_is_webhook_authentic
    signature = '79a3a5291c94340ff0058a6319063757'\
                '68d706357ee86826c3c692e6b9aa6817'
    payload = '{ "a": 1 }'

    assert_false(Button::Utils.is_webhook_authentic('secret', payload, 'XXX'))
    assert_true(Button::Utils.is_webhook_authentic('secret', payload, signature))
    assert_false(Button::Utils.is_webhook_authentic('secret?', payload, signature))
    assert_false(Button::Utils.is_webhook_authentic('secret', '{ "a": 2 }', signature))
  end

  def test_is_webhook_authentic_unicode_payload
    signature = '3040cf48ab225ca539c1d23841175bc2'\
                '2e565cdb0975bd690ecaeca2c39dfcf7'
    payload = "{ \"a\": \u1f60e }"

    assert_true(Button::Utils.is_webhook_authentic('secret', payload, signature))
  end
end
