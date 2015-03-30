require 'openssl'
require 'base64'

module Alipay
  module Sign
    class RSA
      ALIPAY_RSA_PUBLIC_KEY = <<-EOF
-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRA
FljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQE
B/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5Ksi
NG9zpgmLCUYuLkxpLQIDAQAB
-----END PUBLIC KEY-----
      EOF

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
