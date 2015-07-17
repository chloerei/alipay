module Alipay
  module Mobile
    module Sign
      def self.generate(params, options = {})
        params = Utils.stringify_keys(params)
        sign_type = options[:sign_type] || Alipay.sign_type
        key = options[:key] || Alipay.key
        raise ArgumentError, "only support RSA sign_type" if sign_type != 'RSA'

        string = params_to_string(params)
        Alipay::Sign::RSA.sign(key, string)
      end

      def self.params_to_string(params)
        params.map { |key, value| %Q(#{key}="#{value}") }.join('&')
      end
    end
  end
end
