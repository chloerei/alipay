module Alipay
  module Service
    module Wap
      GATEWAY_URL = 'https://wappaygw.alipay.com/service/rest.htm'

      REQ_DATA_REQUIRED_PARAMS = %w( subject out_trade_no total_fee seller_account_name call_back_url )
      WAP_TRADE_REQUIRED_PARAMS = %w( service format v partner req_id req_data )

      def self.trade_create_direct_token(params, options = {})
        params = Utils.stringify_keys(params)

        req_data_PARAMS = { 'seller_account_name' => Alipay.seller_email }.merge(
          Utils.stringify_keys(params.delete('req_data'))
        )

        Alipay::Service.check_required_params(req_data_PARAMS, REQ_DATA_REQUIRED_PARAMS)

        xml = req_data_PARAMS.map {|k, v| "<#{k}>#{v.encode(:xml => :text)}</#{k}>" }.join
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

        Alipay::Service.check_required_params(params, WAP_TRADE_REQUIRED_PARAMS)

        xml = Net::HTTP.get(request_uri(params, options))
        CGI.unescape(xml).scan(/\<request_token\>(.*)\<\/request_token\>/).flatten.first
      end

      AUTH_AND_EXECUTE_REQUIRED_PARAMS = %w( service format v partner )

      def self.auth_and_execute_url(params, options = {})
        params = Utils.stringify_keys(params)
        Alipay::Service.check_required_params(params, ['request_token'])

        req_data_xml = "<auth_and_execute_req><request_token>#{params.delete('request_token')}</request_token></auth_and_execute_req>"

        params = {
          'service'  => 'alipay.wap.auth.authAndExecute',
          'req_data' => req_data_xml,
          'partner'  => options[:pid] || Alipay.pid,
          'format'   => 'xml',
          'v'        => '2.0'
        }.merge(params)

        Alipay::Service.check_required_params(params, AUTH_AND_EXECUTE_REQUIRED_PARAMS)
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
