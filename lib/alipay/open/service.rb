module Alipay
  module Open
    module Service
      OPEN_GATEWAY_URL = "https://openapi.alipay.com/gateway.do"

      FUND_TRANS_TOACCOUNT_TRANSFER_REQUIRED_PARAMS = %w( out_biz_no payee_type payee_account amount )
      def self.alipay_fund_trans_toaccount_transfer(params, options = {})
        Alipay::Service.check_required_params(params, FUND_TRANS_TOACCOUNT_TRANSFER_REQUIRED_PARAMS)

        app_id = options[:app_id] || Alipay.app_id
        key = options[:key] || Alipay.key
        sign_type = (options[:sign_type] || :rsa2).to_s.upcase

        params = {
          "biz_content"    => params.to_json,
          "app_id"         => app_id,
          'method'         => 'alipay.fund.trans.toaccount.transfer',
          'charset'        => 'utf-8',
          'version'        => '1.0',
          'timestamp'      => Time.now.utc.strftime('%Y-%m-%d %H:%M:%S').to_s,
          'sign_type'      => sign_type
        }

        signed_params = get_sign_by_type(params, sign_type)

        uri = URI(::Alipay::Service::OPEN_GATEWAY_URL)
        uri.query = URI.encode_www_form(signed_params)

        Net::HTTP.get(uri)
      end

      def self.get_sign_by_type(params, sign_type)
        string = Alipay::App::Sign.params_to_sorted_string(params)
        sign = case sign_type
        when 'RSA'
          ::Alipay::Sign::RSA.sign(key, string)
        when 'RSA2'
          ::Alipay::Sign::RSA2.sign(key, string)
        else
          raise ArgumentError, "invalid sign_type #{sign_type}, allow value: 'RSA', 'RSA2'"
        end
      end

    end
  end
end
