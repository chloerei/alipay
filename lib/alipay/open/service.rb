module Alipay
  module Open
    module Service
      OPEN_GATEWAY_URL = "https://openapi.alipay.com/gateway.do"

      ALIPAY_RSA_PUBLIC_KEY = <<-EOF
-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDDI6d306Q8fIfCOaTXyiUeJHkr
IvYISRcc73s3vF1ZT7XN8RNPwJxo8pWaJMmvyTn9N4HQ632qJBVHf8sxHi/fEsra
prwCtzvzQETrNRwVxLO5jVmRGi60j8Ue1efIlzPXV9je9mkjzOmdssymZkh2QhUr
CmZYI/FCEa3/cNMW0QIDAQAB
-----END PUBLIC KEY-----
      EOF

      FUND_TRANS_TOACCOUNT_TRANSFER_REQUIRED_PARAMS = %w( out_biz_no payee_type payee_account amount )
      def self.alipay_fund_trans_toaccount_transfer(params, options = {})
        params = Utils.stringify_keys(params)
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

        signed_params = params.merge("sign" => get_sign_by_type(params, key, sign_type))

        uri = URI(::Alipay::Open::Service::OPEN_GATEWAY_URL)
        uri.query = URI.encode_www_form(signed_params)

        Net::HTTP.get(uri)
      end

      ALIPAY_TRADE_WAP_PAY_REQUIRED_PARAMS = %w( subject out_trade_no total_amount product_code )
      def self.alipay_trade_wap_pay_url(params, options = {})
        params = Utils.stringify_keys(params)
        Alipay::Service.check_required_params(params, ALIPAY_TRADE_WAP_PAY_REQUIRED_PARAMS)

        app_id = options[:app_id] || Alipay.app_id
        key = options[:key] || Alipay.key
        sign_type = (options[:sign_type] || :rsa2).to_s.upcase

        real_params = {
          "app_id"         => app_id,
          'method'         => 'alipay.trade.wap.pay',
          'charset'        => 'utf-8',
          'version'        => '1.0',
          'timestamp'      => Time.now.utc.strftime('%Y-%m-%d %H:%M:%S').to_s,
          'sign_type'      => sign_type
        }

        real_params["return_url"] = params["return_url"] unless params["return_url"].nil?
        real_params["notify_url"] = params["notify_url"] unless params["notify_url"].nil?
        params.delete('return_url')
        params.delete('notify_url')
        real_params["biz_content"] = params.to_json

        signed_params = real_params.merge("sign" => get_sign_by_type(real_params, key, sign_type))

        uri = URI(::Alipay::Open::Service::OPEN_GATEWAY_URL)
        uri.query = URI.encode_www_form(signed_params)

        uri.to_s
      end

      def self.get_sign_by_type(params, key, sign_type)
        string = Alipay::App::Sign.params_to_sorted_string(params)
        case sign_type
        when 'RSA'
          ::Alipay::Sign::RSA.sign(key, string)
        when 'RSA2'
          ::Alipay::Sign::RSA2.sign(key, string)
        else
          raise ArgumentError, "invalid sign_type #{sign_type}, allow value: 'RSA', 'RSA2'"
        end
      end

      # 统一收单交易退款接口
      # out_trade_no 和 trade_no 是二选一(必填)
      ALIPAY_TRADE_REFUND_REQUIRED_PARAMS = %w( out_trade_no trade_no refund_amount )
      def self.alipay_trade_refund(params, options = {})
        params = Utils.stringify_keys(params)
        Alipay::Service.check_required_params(params, ALIPAY_TRADE_REFUND_REQUIRED_PARAMS)
        warn("Alipay Warn: missing required option: Either out_trade_no or trade_no must must be provided!") if (['out_trade_no', 'trade_no'] & params.keys) == []

        app_id = options[:app_id] || Alipay.app_id
        key = options[:key] || Alipay.key
        sign_type = (options[:sign_type] || :rsa2).to_s.upcase

        params = {
          "biz_content"    => params.to_json,
          "app_id"         => app_id,
          'method'         => 'alipay.trade.refund',
          'charset'        => 'utf-8',
          'version'        => '1.0',
          'timestamp'      => Time.now.utc.strftime('%Y-%m-%d %H:%M:%S').to_s,
          'sign_type'      => sign_type
        }

        signed_params = params.merge("sign" => get_sign_by_type(params, key, sign_type))

        uri = URI(::Alipay::Open::Service::OPEN_GATEWAY_URL)
        uri.query = URI.encode_www_form(signed_params)

        Net::HTTP.get(uri)
      end

    end
  end
end
