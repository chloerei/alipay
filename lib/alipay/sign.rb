require 'digest/md5'

module Alipay
  module Sign
    MD5 = 1
    RSA = 2

    def self.generate_params(params)
      query = params.sort.map do |key, value|
        "#{key}=#{value}"
      end.join('&')
    end

    def self.generate(params, sign_type=MD5)
      case sign_type
      when MD5
        Digest::MD5.hexdigest("#{generate_params(params)}#{Alipay.key}")
      when RSA
        Base64.encode64(Alipay.rsa_private_key.sign(
          "sha1", params.force_encoding("utf-8")))
      end
    end

    def self.verify?(params, sign_type=MD5)
      params = Utils.stringify_keys(params)
      params.delete('sign_type')
      sign = params.delete('sign')

      case sign_type
      when MD5
        generate(params) == sign
      when RSA
        Alipay.rsa_alipay_public_key.verify(
          "sha1", Base64.decode64(sign), generate_params(params).force_encoding("utf-8"))
      end
    end
  end
end
