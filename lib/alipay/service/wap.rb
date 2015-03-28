module Alipay
  module Service
    module Wap
      GATEWAY_URL = 'https://wappaygw.alipay.com/service/rest.htm'

      TRADE_CREATE_DIRECT_TOKEN_REQUIRED_PARAMS = %w( req_data )
      REQ_DATA_REQUIRED_PARAMS = %w( subject out_trade_no total_fee call_back_url )
      def self.trade_create_direct_token(params, options = {})
        params = Utils.stringify_keys(params)
        Alipay::Service.check_required_params(params, TRADE_CREATE_DIRECT_TOKEN_REQUIRED_PARAMS)

        req_data = Utils.stringify_keys(params.delete('req_data'))
        Alipay::Service.check_required_params(req_data, REQ_DATA_REQUIRED_PARAMS)

        req_data = {
          'seller_account_name' => options[:seller_email] || Alipay.seller_email
        }.merge(req_data)

        xml = req_data.map {|k, v| "<#{k}>#{v.encode(:xml => :text)}</#{k}>" }.join
        req_data_xml = "<direct_trade_create_req>#{xml}</direct_trade_create_req>"

        # About req_id: http://club.alipay.com/read-htm-tid-10078020-fpage-2.html
        params = {
          'service'  => 'alipay.wap.trade.create.direct',
          'req_data' => req_data_xml,
          'partner'  => options[:pid] || Alipay.pid,
          'req_id'   => Time.now.strftime('%Y%m%d%H%M%s'),
          'format'   => 'xml',
          'v'        => '2.0'
        }.merge(params)

        xml = Net::HTTP.get(request_uri(params, options))
        CGI.unescape(xml).scan(/\<request_token\>(.*)\<\/request_token\>/).flatten.first
      end

      AUTH_AND_EXECUTE_REQUIRED_PARAMS = %w( request_token )

      def self.auth_and_execute_url(params, options = {})
        params = Utils.stringify_keys(params)
        Alipay::Service.check_required_params(params, AUTH_AND_EXECUTE_REQUIRED_PARAMS)

        req_data_xml = "<auth_and_execute_req><request_token>#{params.delete('request_token')}</request_token></auth_and_execute_req>"

        params = {
          'service'  => 'alipay.wap.auth.authAndExecute',
          'req_data' => req_data_xml,
          'partner'  => options[:pid] || Alipay.pid,
          'format'   => 'xml',
          'v'        => '2.0'
        }.merge(params)

        request_uri(params, options).to_s
      end

      def self.request_uri(params, options = {})
        uri = URI(GATEWAY_URL)
        uri.query = URI.encode_www_form(sign_params(params, options))
        uri
      end

      SIGN_TYPE_TO_SEC_ID = {
        'MD5' => 'MD5',
        'RSA' => '0001'
      }

      def self.sign_params(params, options = {})
        sign_type = (options['sign_type'] ||= Alipay.sign_type)
        params = params.merge('sec_id' => SIGN_TYPE_TO_SEC_ID[sign_type])
        params.merge('sign' => Alipay::Sign.generate(params, options))
      end
    end
  end
end
