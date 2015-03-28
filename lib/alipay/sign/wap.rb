module Alipay
  module Sign
    module Wap
      SORTED_VERIFY_PARAMS = %w( service v sec_id notify_data )
      def self.verify?(params, options = {})
        params = Utils.stringify_keys(params)
        key = options[:pid] || Alipay.key
        sign = params.delete('sign')

        case params['sec_id']
        when 'MD5'
          verify_md5?(key, sign, params)
        when '0001' # RSA
          raise NotImplementedError, "RSA sign is unimplemented"
        else
          raise ArgumentError, "wrong sec_id, allow value: 'MD5', '0001'"
        end
      end

      def self.params_to_string(params)
        SORTED_VERIFY_PARAMS.map do |key|
          "#{key}=#{params[key]}"
        end.join('&')
      end

      def self.verify_md5?(key, sign, params)
        sign == Digest::MD5.hexdigest("#{params_to_string(params)}#{key}")
      end
    end
  end
end
