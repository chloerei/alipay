require 'digest/md5'
require 'openssl'
require 'base64'

module Alipay
  module Sign
    def self.generate(params)
      query = params.sort.map { |item| item.join('=') }.join('&')
      Digest::MD5.hexdigest("#{query}#{Alipay.key}")
    end

    def self.rsa_sign params
      rsa_string = params.keys.map{|key| %Q{#{key}="#{params[key]}"} }.join("&")
      pri = OpenSSL::PKey::RSA.new(Alipay.key)
      sign = pri.sign('sha1', rsa_string.force_encoding("utf-8"))
      signature = CGI.escape Base64.encode64(sign).gsub("\n", "")
      return signature
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
