require 'openssl'
require 'base64'

module Alipay
  module Sign
    class RSA
      def self.sign(key, string)
        rsa = OpenSSL::PKey::RSA.new(key)
        Base64.encode64(rsa.sign('sha1', string))
      end

      def self.verify?(string, sign)
        rsa = OpenSSL::PKey::RSA.new(ALIPAY_RSA_PUBLIC_KEY)
        rsa.verify('sha1', Base64.decode64(sign), string)
      end
    end
  end
end
