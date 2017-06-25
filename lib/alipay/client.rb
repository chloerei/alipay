module Alipay
  class Client
    def initialize(options)
      options = ::Alipay::Utils.stringify_keys(options)
      @url = options['url']
      @app_id = options['app_id']
      @app_private_key = options['app_private_key']
      @format = options['format'] || 'json'
      @charset = options['charset'] || 'utf-8'
      @alipay_public_key = options['alipay_public_key']
      @sign_type = options['sign_type'] || 'RSA2'
    end

    def request_url(options = {})
      options = {
        app_id: @app_id,
        charset: @charset,
        sign_type: @sign_type,
        version: '1.0',
        timestamp: Time.now.localtime('+08:00').strftime("%Y-%m-%d %H:%M:%S")
      }.merge(options)

      string = options.sort.map { |item| item.join('=') }.join('&')

      sign = case @sign_type
      when 'RSA'
        ::Alipay::Sign::RSA.sign(@app_private_key, string)
      when 'RSA2'
        ::Alipay::Sign::RSA2.sign(@app_private_key, string)
      else
        raise "Unsupported sign_type: #{@sign_type}"
      end

      uri = URI(@url)
      uri.query = URI.encode_www_form(options.merge(sign: sign))
      uri.to_s
    end
  end
end
