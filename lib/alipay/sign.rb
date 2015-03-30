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
        raise ArgumentError, "[Alipay] Invalid sign_type #{sign_type}, allow value: 'MD5', 'RSA', 'DSA'"
      end
    end

    def self.params_to_string(params)
      params.sort.map { |item| item.join('=') }.join('&')
    end

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
        RSA.verify?(string, sign)
      when 'DSA'
        DSA.verify?(string, sign)
      else
        raise ArgumentError, "[Alipay] Invalid sign_type #{sign_type}, allow values: 'MD5', 'RSA', 'DSA'"
      end
    end
  end
end
