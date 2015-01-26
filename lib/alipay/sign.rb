require 'digest/md5'
require 'openssl'
require 'base64'

module Alipay
  module Sign
    def self.generate(params)
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
            "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCdQRT3itozwDJRJq7QkwzoVmNapGq01IxnikUH /pN+OULNRBd7l+MKosSc6wCc3Qwr9sPeQcsPvXh4h6vhRnHVJq7TizBmI9PkYbAEJ7SSuzzx1MCn pxVnusFvgvdJ08LOd4pMrRqMqSzi1aoScRH/Y0tz2Dc3txCKyMgrV8aJnQIDAQAB\n" \
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
