module Alipay
  module App
    module Service
      ALIPAY_TRADE_APP_PAY_REQUIRED_PARAMS = %w( app_id biz_content notify_url )

      def self.alipay_trade_app_pay(params, options = {})
        params = Utils.stringify_keys(params)
        Alipay::Service.check_required_params(params, ALIPAY_TRADE_APP_PAY_REQUIRED_PARAMS)
        key = options[:key] || Alipay.key

        sign_type = options[:sign_type] || :rsa2
        sign_type = sign_type.to_s.upcase
        sign_module = ::Alipay::Sign.const_get(sign_type)

        params = {
          'method'         => 'alipay.trade.app.pay',
          'charset'        => 'utf-8',
          'version'        => '1.0',
          'timestamp'      => Time.now.utc.strftime('%Y-%m-%d %H:%M:%S').to_s,
          'sign_type'      => sign_type
        }.merge(params)

        string = Alipay::App::Sign.params_to_sorted_string(params)
        sign = sign_module.sign(key, string)

        Alipay::App::Sign.params_to_encoded_string params.merge('sign' => sign)
      end
    end
  end
end
