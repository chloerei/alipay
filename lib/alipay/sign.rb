require 'digest/md5'
require 'openssl'
require 'base64'

module Alipay
  module Sign
    def self.generate(params, options = {})
      params = Utils.stringify_keys(params)
      sign_type = options[:sign_type] || Alipay.sign_type
      key = options[:key] || Alipay.key

      case sign_type
      when 'MD5'
        generate_md5(key, params)
      when 'RSA'
        raise NotImplementedError, "RSA sign is unimplemented"
      when 'DSA'
        raise NotImplementedError, "DSA sign is unimplemented"
      else
        raise ArgumentError, "wrong sign_type #{sign_type}, allow values: 'MD5', 'RSA', 'DSA'"
      end
    end

    def self.generate_md5(key, params)
      Digest::MD5.hexdigest("#{params_to_string(params)}#{key}")
    end

    def self.params_to_string(params)
      params.sort.map { |item| item.join('=') }.join('&')
    end

    def self.verify?(params)
      params = Utils.stringify_keys(params)

      sign_type = params.delete('sign_type')

      case sign_type
      when 'MD5'
        verify_md5?(params)
      when 'RSA'
        verify_rsa?(params)
      when 'DSA'
        raise NotImplementedError, "DSA verify is unimplemented"
      else
        raise ArgumentError, "wrong sign_type #{sign_type}, allow values: 'MD5', 'RSA', 'DSA'"
      end
    end

    def self.verify_md5?(params)
      key = params.delete('key') || Alipay.key
      sign = params.delete('sign')
      generate_md5(key, params) == sign
    end

    ALIPAY_RSA_PUBLIC_KEY = <<-EOF
-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRA
FljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQE
B/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5Ksi
NG9zpgmLCUYuLkxpLQIDAQAB
-----END PUBLIC KEY-----
    EOF

    def self.verify_rsa?(params)
      pkey = OpenSSL::PKey::RSA.new(ALIPAY_RSA_PUBLIC_KEY)
      digest = OpenSSL::Digest::SHA1.new
      sign = params.delete('sign')

      pkey.verify(digest, Base64.decode64(sign), params_to_string(params))
    end
  end
end
