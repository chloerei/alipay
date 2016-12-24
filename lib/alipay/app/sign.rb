require 'erb'

module Alipay
  module App
    module Sign
      ALIPAY_RSA_PUBLIC_KEY = <<-EOF
-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDDI6d306Q8fIfCOaTXyiUeJHkr
IvYISRcc73s3vF1ZT7XN8RNPwJxo8pWaJMmvyTn9N4HQ632qJBVHf8sxHi/fEsra
prwCtzvzQETrNRwVxLO5jVmRGi60j8Ue1efIlzPXV9je9mkjzOmdssymZkh2QhUr
CmZYI/FCEa3/cNMW0QIDAQAB
-----END PUBLIC KEY-----
      EOF

      def self.verify?(params)
        params = ::Alipay::Utils.stringify_keys(params)

        sign_type = params.delete('sign_type')
        sign = params.delete('sign')
        string = ::Alipay::Sign.params_to_string(params)

        case sign_type
        when 'RSA'
          ::Alipay::Sign::RSA.verify?(ALIPAY_RSA_PUBLIC_KEY, string, sign)
        else
          false
        end
      end

      def self.params_to_sorted_string(params)
        params.sort.map { |key, value| %Q(#{key}=#{value.to_s}) }.join('&')
      end

      def self.params_to_encoded_string(params)
        params.sort.map { |key, value| %Q(#{key}=#{ERB::Util.url_encode(value.to_s)}) }.join('&')
      end
    end
  end
end
