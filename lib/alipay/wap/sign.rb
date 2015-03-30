module Alipay
  module Wap
    module Sign
      SORTED_VERIFY_PARAMS = %w( service v sec_id notify_data )
      def self.verify?(params, options = {})
        params = Utils.stringify_keys(params)
        key = options[:pid] || Alipay.key
        sign = params.delete('sign')

        case params['sec_id']
        when 'MD5'
          ::Alipay::Sign::MD5.verify?("#{params_to_string(params)}#{key}", sign)
        when '0001' # RSA
          ::Alipay::Sign::RSA.verify?(params_to_string(params), sign)
        else
          raise ArgumentError, "[Alipay] Invalid sec_id, allow value: 'MD5', '0001'"
        end
      end

      def self.params_to_string(params)
        SORTED_VERIFY_PARAMS.map do |key|
          "#{key}=#{params[key]}"
        end.join('&')
      end
    end
  end
end
