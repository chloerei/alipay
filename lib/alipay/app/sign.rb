require 'erb'

module Alipay
  module App
    module Sign
      def self.verify?(params, options = {})
        params = ::Alipay::Utils.stringify_keys(params)

        sign_type = params.delete('sign_type').upcase
        unless options[:sign_type].to_s.upcase == sign_type
          raise "sign_type not match: params: #{params[:sign_type]} options: #{options[:sign_type]}"
        end

        sign = params.delete('sign')
        string = ::Alipay::Sign.params_to_string(params)

        case sign_type
        when 'RSA'
          ::Alipay::Sign::RSA.verify?(options[:key], string, sign)
        when 'RSA2'
          ::Alipay::Sign::RSA2.verify?(options[:key], string, sign)
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
