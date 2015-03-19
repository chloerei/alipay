require 'digest/md5'
require 'openssl'
require 'base64'

module Alipay
  module Sign
    def self.generate(params)
      sign_type = params.delete('sign_type') || Alipay.sign_type

      case sign_type
      when 'MD5'
        generate_md5(params)
      else
        raise ArgumentError, "wrong sign_type #{sign_type}, allow value is 'MD5', 'RSA', 'DSA'"
      end
    end

    def self.generate_md5(params)
      query = params.sort.map { |item| item.join('=') }.join('&')
      Digest::MD5.hexdigest("#{query}#{Alipay.key}")
    end

    def self.verify?(params)
      params = Utils.stringify_keys(params)
      params.delete('sign_type')
      sign = params.delete('sign')

      generate(params) == sign
    end

    module Wap
      SORTED_VERIFY_PARAMS = %w( service v sec_id notify_data )

      def self.verify?(params)
        params = Utils.stringify_keys(params)

        query = SORTED_VERIFY_PARAMS.map do |key|
          "#{key}=#{params[key]}"
        end.join('&')

        params['sign'] == Digest::MD5.hexdigest("#{query}#{Alipay.key}")
      end
    end

    module App
      # Alipay public key
      PEM = "-----BEGIN PUBLIC KEY-----\n" \
            "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRA\n" \
            "FljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQE\n" \
            "B/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5Ksi\n" \
            "NG9zpgmLCUYuLkxpLQIDAQAB\n" \
            "-----END PUBLIC KEY-----"

      def self.verify?(params)
        params = Utils.stringify_keys(params)

        pkey = OpenSSL::PKey::RSA.new(PEM)
        digest = OpenSSL::Digest::SHA1.new

        params.delete('sign_type')
        sign = params.delete('sign')
        to_sign = params.sort.map { |item| item.join('=') }.join('&')

        pkey.verify(digest, Base64.decode64(sign), to_sign)
      end
    end
  end
end
