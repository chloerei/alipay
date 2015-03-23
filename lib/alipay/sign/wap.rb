module Alipay
  module Sign
    module Wap
      SORTED_VERIFY_PARAMS = %w( service v sec_id notify_data )

      def self.verify?(params)
        params = Utils.stringify_keys(params)

        query = SORTED_VERIFY_PARAMS.map do |key|
          "#{key}=#{params[key]}"
        end.join('&')

        params['sign'] == Digest::MD5.hexdigest("#{query}#{Alipay.key}")
      end
    end
  end
end
