module Alipay
  module Wap
    module Sign
      ALIPAY_RSA_PUBLIC_KEY = <<-EOF
-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCQwpCPC4oB+clYNBkKQx3gfyFl
Ut3cpRr5oErt OypLKh6j1UmTDSpfsac29h1kC0HIvLmxWbPuoxcsKDlclgRPeWn
IxrpSF9k5Fu6SRy3+AOdIKrDO SHQ7VwUsNih2OnPbztMSMplGnQCBa1iec2r+38
Udmh5Ua2xg6IEfk493VQIDAQAB
-----END PUBLIC KEY-----
      EOF

      def self.verify?(params, options = {})
        params = Utils.stringify_keys(params)
        sign = params.delete('sign')
        string = params_to_string(params)

        case params['sec_id']
        when 'MD5'
          key = options[:pid] || Alipay.key
          ::Alipay::Sign::MD5.verify?(key, string, sign)
        when '0001' # RSA
          ::Alipay::Sign::RSA.verify?(ALIPAY_RSA_PUBLIC_KEY, string, sign)
        else
          false
        end
      end

      SORTED_VERIFY_PARAMS = %w( service v sec_id notify_data )
      def self.params_to_string(params)
        SORTED_VERIFY_PARAMS.map do |key|
          "#{key}=#{params[key]}"
        end.join('&')
      end
    end
  end
end
