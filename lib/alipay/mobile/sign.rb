module Alipay
  module Mobile
    module Sign
      def self.params_to_string(params)
        params.map { |key, value| %Q(#{key}="#{value}") }.join('&')
      end
    end
  end
end
