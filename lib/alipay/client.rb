module Alipay
  class Client
    # Create a client to manage all API request.
    #
    # Example:
    #
    #   alipay_client = Alipay::Client.new(
    #     url: 'https://openapi.alipaydev.com/gateway.do',
    #     app_id: '2016000000000000',
    #     app_private_key: APP_PRIVATE_KEY,
    #     alipay_public_key: ALIPAY_PUBLIC_KEY
    #   )
    #
    # Options:
    #
    # [:url]  Alipay Open API gateway,
    #         'https://openapi.alipaydev.com/gateway.do'(Sandbox) or
    #         'https://openapi.alipay.com/gateway.do'(Production).
    #
    # [:app_id] Your APP ID.
    #
    # [:app_private_key] APP private key.
    #
    # [:alipay_public_key] Alipay public key.
    #
    # [:format] default is 'json', only support 'json'.
    #
    # [:charset] default is 'UTF-8', only support 'UTF-8'.
    #
    # [:sign_type] default is 'RSA2', support 'RSA2', 'RSA', 'RSA2' is recommended.
    def initialize(options)
      options = ::Alipay::Utils.stringify_keys(options)
      @url = options['url']
      @app_id = options['app_id']
      @app_private_key = options['app_private_key']
      @alipay_public_key = options['alipay_public_key']
      @format = options['format'] || 'json'
      @charset = options['charset'] || 'UTF-8'
      @sign_type = options['sign_type'] || 'RSA2'
    end

    # Generate a query string that use for APP SDK excute.
    #
    # Example:
    #
    #   alipay_client.sdk_execute(
    #     method: 'alipay.trade.page.pay',
    #     biz_content: {
    #       out_trade_no: '20160401000000',
    #       product_code: 'QUICK_MSECURITY_PAY',
    #       total_amount: '0.01',
    #       subject: 'test'
    #     }.to_json,
    #     timestamp: '2016-04-01 00:00:00'
    #   )
    #   # => 'app_id=2016000000000000&charset=utf-8&sig....'
    def sdk_execute(params)
      params = prepare_params(params)

      URI.encode_www_form(params)
    end

    # Generate a url that use to redirect user to Alipay payment page.
    #
    # Example:
    #
    #   assert_equal url, @client.page_execute_url(
    #     method: 'alipay.trade.page.pay',
    #     biz_content: {
    #       out_trade_no: '20160401000000',
    #       product_code: 'FAST_INSTANT_TRADE_PAY',
    #       total_amount: '0.01',
    #       subject: 'test'
    #     }.to_json,
    #     timestamp: '2016-04-01 00:00:00'
    #   )
    #   # => 'https://openapi.alipaydev.com/gateway.do?app_id=2016...'
    def page_execute_url(params)
      params = prepare_params(params)

      uri = URI(@url)
      uri.query = URI.encode_www_form(params)
      uri.to_s
    end

    # Generate a form string that use to render in view and auto POST to
    # Alipay server.
    #
    # Example:
    #
    #   assert_equal url, @client.page_execute_form(
    #     method: 'alipay.trade.page.pay',
    #     biz_content: {
    #       out_trade_no: '20160401000000',
    #       product_code: 'FAST_INSTANT_TRADE_PAY',
    #       total_amount: '0.01',
    #       subject: 'test'
    #     }.to_json,
    #     timestamp: '2016-04-01 00:00:00'
    #   )
    #   # => '<form id='alipaysubmit' name='alipaysubmit' action=...'
    def page_execute_form(params)
      params = prepare_params(params)

      html = %Q(<form id='alipaysubmit' name='alipaysubmit' action='#{@url}' method='POST'>)
      params.each do |key, value|
        html << %Q(<input type='hidden' name='#{key}' value='#{value.gsub("'", "&apos;")}'/>)
      end
      html << "<input type='submit' value='ok' style='display:none'></form>"
      html << "<script>document.forms['alipaysubmit'].submit();</script>"
      html
    end

    # Immediately make a API request to Alipay and return response body.
    #
    # Example:
    #
    #   @client.execute(
    #     method: 'alipay.data.dataservice.bill.downloadurl.query',
    #     biz_content: {
    #       bill_type: 'trade',
    #       bill_date: '2016-04-01'
    #     }.to_json
    #   )
    #   # => '{ "alipay_data_dataservice_bill_downloadurl_query_response":{...'
    def execute(params)
      params = prepare_params(params)

      Net::HTTP.post_form(URI(@url), params).body
    end

    # Generate sign for params.
    def sign(params)
      string = params_to_string(params)

      case @sign_type
      when 'RSA'
        ::Alipay::Sign::RSA.sign(@app_private_key, string)
      when 'RSA2'
        ::Alipay::Sign::RSA2.sign(@app_private_key, string)
      else
        raise "Unsupported sign_type: #{@sign_type}"
      end
    end

    # Verify Alipay notification.
    #
    # Example:
    #
    #   params = {
    #     out_trade_no: '20160401000000',
    #     trade_status: 'TRADE_SUCCESS'
    #     sign_type: 'RSA2',
    #     sign: '...'
    #   }
    #   alipay_client.verify?(params)
    #   # => true / false
    def verify?(params)
      params = Utils.stringify_keys(params)
      return false if params['sign_type'] != @sign_type

      sign = params.delete('sign')
      string = params_to_string(params)
      case @sign_type
      when 'RSA'
        ::Alipay::Sign::RSA.verify?(@alipay_public_key, string, sign)
      when 'RSA2'
        ::Alipay::Sign::RSA2.verify?(@alipay_public_key, string, sign)
      else
        raise "Unsupported sign_type: #{@sign_type}"
      end
    end

    private

    def prepare_params(params)
      params = {
        'app_id' => @app_id,
        'charset' => @charset,
        'sign_type' => @sign_type,
        'version' => '1.0',
        'timestamp' => Time.now.localtime('+08:00').strftime("%Y-%m-%d %H:%M:%S")
      }.merge(::Alipay::Utils.stringify_keys(params))
      params['sign'] = sign(params)
      params
    end

    def params_to_string(params)
      params.sort.map { |item| item.join('=') }.join('&')
    end
  end
end
