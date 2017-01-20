module Alipay
  module App
    module Service
      ALIPAY_TRADE_APP_PAY_REQUIRED_PARAMS = %w( app_id biz_content notify_url )

      def self.alipay_trade_app_pay(params, options = {})
        params = Utils.stringify_keys(params)
        Alipay::Service.check_required_params(params, ALIPAY_TRADE_APP_PAY_REQUIRED_PARAMS)
        key = options[:key] || Alipay.key

        params = {
          'method'         => 'alipay.trade.app.pay',
          'charset'        => 'utf-8',
          'version'        => '1.0',
          'timestamp'      => Time.now.utc.strftime('%Y-%m-%d %H:%M:%S').to_s,
          'sign_type'      => 'RSA'
        }.merge(params)

        string = Alipay::App::Sign.params_to_sorted_string(params)
        sign = Alipay::Sign::RSA.sign(key, string)
        params = params.merge({'sign' => sign})
        encoded_string = Alipay::App::Sign.params_to_encoded_string(params)
        %Q(#{encoded_string})

      end
    end
  end
end
