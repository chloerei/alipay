require 'gyoku'
require 'open-uri'

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

        req_data_xml = Gyoku.xml({ :direct_trade_create_req => req_data_options }, { :key_converter => :none })

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

        open("#{GATEWAY_URL}?#{query_string(options)}").read
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
        "#{GATEWAY_URL}?#{query_string(options)}"
      end

      def self.query_string(options)
        options.merge!('sec_id' => 'MD5')

        options.merge('sign' => Alipay::Sign.generate(options)).map do |key, value|
          "#{CGI.escape(key.to_s)}=#{CGI.escape(value.to_s)}"
        end.join('&')
      end
    end
  end
end
