require 'digest/md5'

module Alipay
  module Sign
    def self.generate(params)
      query = params.sort.map do |key, value|
        "#{key}=#{value}"
      end.join('&')

      Digest::MD5.hexdigest("#{query}#{Alipay.key}")
    end

    def self.verify?(params)
      params = Utils.stringify_keys(params)
      params.delete('sign_type')
      sign = params.delete('sign')

      generate(params) == sign
    end

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
