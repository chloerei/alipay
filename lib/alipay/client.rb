module Alipay
  class Client
    def initialize(url:, app_id:, app_private_key:, format: 'json', charset: 'utf-8', alipay_public_key:, sign_type: 'RSA2')
      @url = url
      @app_id = app_id
      @app_private_key = app_private_key
      @format = format
      @charset = charset
      @alipay_public_key = alipay_public_key
      @sign_type = sign_type
    end
  end
end
