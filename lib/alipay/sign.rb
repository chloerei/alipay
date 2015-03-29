module Alipay
  module Sign
    def self.generate(params, options = {})
      params = Utils.stringify_keys(params)
      sign_type = options[:sign_type] || Alipay.sign_type

      case sign_type
      when 'MD5'
        key = options[:key] || Alipay.key
        MD5.sign("#{params_to_string(params)}#{key}")
      when 'RSA'
        RSA.sign(params_to_string(params))
      when 'DSA'
        DSA.sign(params_to_string(params))
      else
        raise ArgumentError, "[Alipay] Invalid sign_type #{sign_type}, allow values: 'MD5', 'RSA', 'DSA'"
      end
    end

    def self.params_to_string(params)
      params.sort.map { |item| item.join('=') }.join('&')
    end

    def self.verify?(params, options = {})
      params = Utils.stringify_keys(params)

      sign_type = params.delete('sign_type')
      sign = params.delete('sign')

      case sign_type
      when 'MD5'
        key = options[:key] || Alipay.key
        MD5.verify?("#{params_to_string(params)}#{key}", sign)
      when 'RSA'
        RSA.verify?(params_to_string(params), sign)
      when 'DSA'
        DSA.verify?(params_to_string(params), sign)
      else
        raise ArgumentError, "[Alipay] Invalid sign_type #{sign_type}, allow values: 'MD5', 'RSA', 'DSA'"
      end
    end
  end
end
