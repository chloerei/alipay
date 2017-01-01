module Alipay
  module Sign
    def self.generate(params, options = {})
      params = Utils.stringify_keys(params)
      sign_type = options[:sign_type] || Alipay.sign_type
      key = options[:key] || Alipay.key
      string = params_to_string(params)

      case sign_type
      when 'MD5'
        MD5.sign(key, string)
      when 'RSA'
        RSA.sign(key, string)
      when 'DSA'
        DSA.sign(key, string)
      else
        raise ArgumentError, "invalid sign_type #{sign_type}, allow value: 'MD5', 'RSA', 'DSA'"
      end
    end

    ALIPAY_RSA_PUBLIC_KEY = <<-EOF
-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDRLMPDWm4Xwg86xXpCN7YmVNL6
5yHpqdUfC/bbrgTYQ+BYDGtZq7nDFu3QuQ0ZAp4U1ZygfgXu6bkg46VLdCZgFdC0
jxU43yB4nhyYKCQppuZ3Pa/rFOjYQdOTEqYArfN+7HRcQn0/C3YVLyY/X17n1px3
AAwGWPJvcXAthGu6mwIDAQAB
-----END PUBLIC KEY-----
    EOF

    def self.verify?(params, options = {})
      params = Utils.stringify_keys(params)

      sign_type = params.delete('sign_type')
      sign = params.delete('sign')
      string = params_to_string(params)

      case sign_type
      when 'MD5'
        key = options[:key] || Alipay.key
        MD5.verify?(key, string, sign)
      when 'RSA'
        RSA.verify?(ALIPAY_RSA_PUBLIC_KEY, string, sign)
      when 'DSA'
        DSA.verify?(string, sign)
      else
        false
      end
    end

    def self.params_to_string(params)
      params.sort.map { |item| item.join('=') }.join('&')
    end
  end
end
