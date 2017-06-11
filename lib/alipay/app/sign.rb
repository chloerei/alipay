require 'erb'

module Alipay
  module App
    module Sign
      def self.verify?(params, options = {})
        params = ::Alipay::Utils.stringify_keys(params)

        sign_type = params.delete('sign_type').upcase
        unless options[:sign_type].to_s.upcase == sign_type
          "Alipay::App::Sign.verify? : invalid params[sign_type]: #{sign_type}"
        end

        sign = params.delete('sign')
        string = ::Alipay::Sign.params_to_string(params)

        sign_module = ::Alipay::Sign.const_get(sign_type)
        sign_module.verify?(options[:key], string, sign)
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
