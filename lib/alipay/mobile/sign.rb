module Alipay
  module Mobile
    module Sign
      def self.params_to_string(params)
        params.map { |key, value| %Q(#{key}="#{value}") }.join('&')
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
