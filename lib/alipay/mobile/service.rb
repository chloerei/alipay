module Alipay
  module Mobile
    module Service
      MOBILE_SECURITY_PAY_REQUIRED_PARAMS = %w( notify_url out_trade_no subject total_fee body )
      ALIPAY_TRADE_APP_PAY_REQUIRED_PARAMS = %w( app_id biz_content notify_url )

      def self.mobile_securitypay_pay_string(params, options = {})
        params = Utils.stringify_keys(params)
        Alipay::Service.check_required_params(params, MOBILE_SECURITY_PAY_REQUIRED_PARAMS)
        sign_type = options[:sign_type] || Alipay.sign_type
        key = options[:key] || Alipay.key
        raise ArgumentError, "only support RSA sign_type" if sign_type != 'RSA'

        params = {
          'service'        => 'mobile.securitypay.pay',
          '_input_charset' => 'utf-8',
          'partner'        => options[:pid] || Alipay.pid,
          'seller_id'      => options[:pid] || Alipay.pid,
          'payment_type'   => '1'
        }.merge(params)

        string = Alipay::Mobile::Sign.params_to_string(params)
        sign = CGI.escape(Alipay::Sign::RSA.sign(key, string))

        %Q(#{string}&sign="#{sign}"&sign_type="RSA")
      end

      def self.alipay_trade_app_pay(params, options = {})
        params = Utils.stringify_keys(params)
        Alipay::Service.check_required_params(params, ALIPAY_TRADE_APP_PAY_REQUIRED_PARAMS)
        sign_type = options[:sign_type] || Alipay.sign_type
        key = options[:key] || Alipay.key
        raise ArgumentError, "only support RSA sign_type" if sign_type != 'RSA'

        params = {
          'method'         => 'alipay.trade.app.pay',
          'charset'        => 'utf-8',
          'version'        => '1.0',
          'timestamp'      => DateTime.now.utc.strftime('%Y-%m-%d %H:%M:%S').to_s,
          'sign_type'      => sign_type
        }.merge(params)

        string = Alipay::Mobile::Sign.params_to_sorted_string(params)
        sign = CGI.escape(Alipay::Sign::RSA.sign(key, string))
        encoded_string = Alipay::Mobile::Sign.params_to_encoded_string(params)

        %Q(#{encoded_string}&sign=#{sign})
      end

    end
  end
end
