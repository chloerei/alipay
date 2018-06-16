module Alipay
  module Mobile
    module Service
      MOBILE_SECURITY_PAY_REQUIRED_PARAMS = %w( notify_url out_trade_no subject total_fee body )
      def self.mobile_securitypay_pay_string(params, options = {})
        params = Utils.stringify_keys(params)
        Alipay::Service.check_required_params(params, MOBILE_SECURITY_PAY_REQUIRED_PARAMS)
        sign_type = options[:sign_type] || Alipay.sign_type
        key = options[:key] || Alipay.key
        raise ArgumentError, "only support RSA sign_type" if sign_type != 'RSA'

        params = {
          'service'        => 'mobile.securitypay.pay',
          '_input_charset' => 'utf-8',
          'partner'        => options[:partner]   || options[:pid] || Alipay.pid,
          'seller_id'      => options[:seller_id] || options[:pid] || Alipay.pid,
          'payment_type'   => '1'
        }.merge(params)

        string = Alipay::Mobile::Sign.params_to_string(params)
        sign = CGI.escape(Alipay::Sign::RSA.sign(key, string))

        %Q(#{string}&sign="#{sign}"&sign_type="RSA")
      end
    end
  end
end
