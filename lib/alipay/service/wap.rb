module Alipay
  module Service
    module Wap
      GATEWAY_URL = 'https://wappaygw.alipay.com/service/rest.htm'

      REQ_DATA_REQUIRED_OPTIONS = %w( subject out_trade_no total_fee seller_account_name call_back_url )
      WAP_TRADE_REQUIRED_OPTIONS = %w( service format v partner req_id req_data )

      def self.trade_create_direct_token(options)
        options = Utils.stringify_keys(options)

        req_data_options = { 'seller_account_name' => Alipay.seller_email }.merge(
          Utils.stringify_keys(options.delete('req_data'))
        )

        Alipay::Service.check_required_options(req_data_options, REQ_DATA_REQUIRED_OPTIONS)

        xml = req_data_options.map {|k, v| "<#{k}>#{v.encode(:xml => :text)}</#{k}>" }.join
        req_data_xml = "<direct_trade_create_req>#{xml}</direct_trade_create_req>"

        # About req_id: http://club.alipay.com/read-htm-tid-10078020-fpage-2.html
        options = {
          'service'  => 'alipay.wap.trade.create.direct',
          'req_data' => req_data_xml,
          'partner'  => Alipay.pid,
          'req_id'   => Time.now.strftime('%Y%m%d%H%M%s'),
          'format'   => 'xml',
          'v'        => '2.0'
        }.merge(options)

        Alipay::Service.check_required_options(options, WAP_TRADE_REQUIRED_OPTIONS)

        xml = Net::HTTP.get(request_uri(options))
        CGI.unescape(xml).scan(/\<request_token\>(.*)\<\/request_token\>/).flatten.first
      end

      AUTH_AND_EXECUTE_REQUIRED_OPTIONS = %w( service format v partner )

      def self.auth_and_execute(options)
        options = Utils.stringify_keys(options)
        Alipay::Service.check_required_options(options, ['request_token'])

        req_data_xml = "<auth_and_execute_req><request_token>#{options.delete('request_token')}</request_token></auth_and_execute_req>"

        options = {
          'service'  => 'alipay.wap.auth.authAndExecute',
          'req_data' => req_data_xml,
          'partner'  => Alipay.pid,
          'format'   => 'xml',
          'v'        => '2.0'
        }.merge(options)

        Alipay::Service.check_required_options(options, AUTH_AND_EXECUTE_REQUIRED_OPTIONS)
        request_uri(options).to_s
      end

      def self.request_uri(options)
        uri = URI(GATEWAY_URL)
        uri.query = URI.encode_www_form(sign_params(options))
        uri
      end

      def self.sign_params(params)
        sign_type = (params['sec_id'] ||= Alipay.sign_type)
        params.merge('sign'   => Alipay::Sign.generate(params.merge('sign_type' => sign_type)))
      end
    end
  end
end
