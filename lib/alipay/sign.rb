module Alipay
  module Sign
    def self.generate(params)
      query = params.sort.map do |key, value|
        "#{key}=#{value}"
      end.join('&')

      Digest::MD5.hexdigest("#{query}#{Alipay.key}")
    end

    def self.verify?(params)
      params = Utils.symbolize_keys(params)
      params.delete(:sign_type)
      sign = params.delete(:sign)

      generate(params) == sign
    end
  end
end
