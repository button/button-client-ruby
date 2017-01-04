require 'openssl'

module Button
  module Utils
    # Used to verify that requests sent to a webhook endpoint are from Button
    # and that their payload can be trusted. Returns true if a webhook request
    # body matches the sent signature and false otherwise.
    #
    def is_webhook_authentic(webhook_secret, request_body, sent_signature)
      computed_signature = OpenSSL::HMAC.hexdigest(
        OpenSSL::Digest.new('sha256'),
        webhook_secret,
        request_body
      )

      return sent_signature == computed_signature
    end

    module_function :is_webhook_authentic
  end
end