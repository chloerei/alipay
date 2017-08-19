module Alipay
  module Service
    GATEWAY_URL = 'https://mapi.alipay.com/gateway.do'

    CREATE_PARTNER_TRADE_BY_BUYER_REQUIRED_PARAMS = %w( out_trade_no subject logistics_type logistics_fee logistics_payment price quantity )
    def self.create_partner_trade_by_buyer_url(params, options = {})
      params = Utils.stringify_keys(params)
      check_required_params(params, CREATE_PARTNER_TRADE_BY_BUYER_REQUIRED_PARAMS)

      params = {
        'service'        => 'create_partner_trade_by_buyer',
        '_input_charset' => 'utf-8',
        'partner'        => options[:pid] || Alipay.pid,
        'seller_id'      => options[:pid] || Alipay.pid,
        'payment_type'   => '1'
      }.merge(params)

      request_uri(params, options).to_s
    end

    TRADE_CREATE_BY_BUYER_REQUIRED_PARAMS = %w( out_trade_no subject logistics_type logistics_fee logistics_payment price quantity )
    def self.trade_create_by_buyer_url(params, options = {})
      params = Utils.stringify_keys(params)
      check_required_params(params, TRADE_CREATE_BY_BUYER_REQUIRED_PARAMS)

      params = {
        'service'        => 'trade_create_by_buyer',
        '_input_charset' => 'utf-8',
        'partner'        => options[:pid] || Alipay.pid,
        'seller_id'      => options[:pid] || Alipay.pid,
        'payment_type'   => '1'
      }.merge(params)

      request_uri(params, options).to_s
    end

    CREATE_DIRECT_PAY_BY_USER_REQUIRED_PARAMS = %w( out_trade_no subject )
    def self.create_direct_pay_by_user_url(params, options = {})
      params = Utils.stringify_keys(params)
      check_required_params(params, CREATE_DIRECT_PAY_BY_USER_REQUIRED_PARAMS)

      if Alipay.debug_mode? and params['total_fee'].nil? and (params['price'].nil? || params['quantity'].nil?)
        warn("Alipay Warn: total_fee or (price && quantity) must be set")
      end

      params = {
        'service'        => 'create_direct_pay_by_user',
        '_input_charset' => 'utf-8',
        'partner'        => options[:pid] || Alipay.pid,
        'seller_id'      => options[:pid] || Alipay.pid,
        'payment_type'   => '1'
      }.merge(params)

      request_uri(params, options).to_s
    end

    CREATE_DIRECT_PAY_BY_USER_WAP_REQUIRED_PARAMS = %w( out_trade_no subject total_fee )
    def self.create_direct_pay_by_user_wap_url(params, options = {})
      params = Utils.stringify_keys(params)
      check_required_params(params, CREATE_DIRECT_PAY_BY_USER_WAP_REQUIRED_PARAMS)

      params = {
        'service'        => 'alipay.wap.create.direct.pay.by.user',
        '_input_charset' => 'utf-8',
        'partner'        => options[:pid] || Alipay.pid,
        'seller_id'      => options[:pid] || Alipay.pid,
        'payment_type'   => '1'
      }.merge(params)

      request_uri(params, options).to_s
    end

    CREATE_REFUND_URL_REQUIRED_PARAMS = %w( batch_no data notify_url )
    def self.refund_fastpay_by_platform_pwd_url(params, options = {})
      params = Utils.stringify_keys(params)
      check_required_params(params, CREATE_REFUND_URL_REQUIRED_PARAMS)

      data = params.delete('data')
      detail_data = data.map do|item|
        item = Utils.stringify_keys(item)
        "#{item['trade_no']}^#{item['amount']}^#{item['reason']}"
      end.join('#')

      params = {
        'service'        => 'refund_fastpay_by_platform_pwd',
        '_input_charset' => 'utf-8',
        'partner'        => options[:pid] || Alipay.pid,
        'seller_user_id' => options[:pid] || Alipay.pid,
        'refund_date'    => Time.now.strftime('%Y-%m-%d %H:%M:%S'),
        'batch_num'      => data.size,
        'detail_data'    => detail_data
      }.merge(params)

      request_uri(params, options).to_s
    end

    CREATE_FOREX_SINGLE_REFUND_URL_REQUIRED_PARAMS = %w( out_return_no out_trade_no return_amount currency reason )
    def self.forex_refund_url(params, options = {})
      params = Utils.stringify_keys(params)
      check_required_params(params, CREATE_FOREX_SINGLE_REFUND_URL_REQUIRED_PARAMS)

      params = {
        'service'        => 'forex_refund',
        'partner'        => options[:pid] || Alipay.pid,
        '_input_charset' => 'utf-8',
        'gmt_return'     => Time.now.getlocal('+08:00').strftime('%Y%m%d%H%M%S')
      }.merge(params)

      request_uri(params, options).to_s
    end

    SEND_GOODS_CONFIRM_BY_PLATFORM_REQUIRED_PARAMS = %w( trade_no logistics_name )
    SEND_GOODS_CONFIRM_BY_PLATFORM_OPTIONAL_PARAMS = %w( transport_type create_transport_type )
    def self.send_goods_confirm_by_platform(params, options = {})
      params = Utils.stringify_keys(params)
      check_required_params(params, SEND_GOODS_CONFIRM_BY_PLATFORM_REQUIRED_PARAMS)
      check_optional_params(params, SEND_GOODS_CONFIRM_BY_PLATFORM_OPTIONAL_PARAMS)

      params = {
        'service'        => 'send_goods_confirm_by_platform',
        'partner'        => options[:pid] || Alipay.pid,
        '_input_charset' => 'utf-8'
      }.merge(params)

      Net::HTTP.get(request_uri(params, options))
    end

    CREATE_FOREX_TRADE_REQUIRED_PARAMS = %w( notify_url subject out_trade_no currency )
    CREATE_FOREX_TRADE_OPTIONAL_PARAMS = %w( total_fee rmb_fee )
    def self.create_forex_trade_url(params, options = {})
      params = Utils.stringify_keys(params)
      check_required_params(params, CREATE_FOREX_TRADE_REQUIRED_PARAMS)
      check_optional_params(params, CREATE_FOREX_TRADE_OPTIONAL_PARAMS)

      params = {
        'service'         => 'create_forex_trade',
        '_input_charset'  => 'utf-8',
        'partner'         => options[:pid] || Alipay.pid,
      }.merge(params)

      request_uri(params, options).to_s
    end

    CLOSE_TRADE_REQUIRED_OPTIONAL_PARAMS = %w( trade_no out_order_no )
    def self.close_trade(params, options = {})
      params = Utils.stringify_keys(params)
      check_optional_params(params, CLOSE_TRADE_REQUIRED_OPTIONAL_PARAMS)

      params = {
        'service'        => 'close_trade',
        '_input_charset' => 'utf-8',
        'partner'        => options[:pid] || Alipay.pid
      }.merge(params)

      Net::HTTP.get(request_uri(params, options))
    end

    SINGLE_TRADE_QUERY_OPTIONAL_PARAMS = %w( trade_no out_trade_no )
    def self.single_trade_query(params, options = {})
      params = Utils.stringify_keys(params)
      check_optional_params(params, SINGLE_TRADE_QUERY_OPTIONAL_PARAMS)

      params =   {
        "service"         => 'single_trade_query',
        "_input_charset"  => "utf-8",
        "partner"         => options[:pid] || Alipay.pid,
      }.merge(params)

      Net::HTTP.get(request_uri(params, options))
    end

    def self.account_page_query(params, options = {})
      params = {
        service: 'account.page.query',
        _input_charset: 'utf-8',
        partner: options[:pid] || Alipay.pid,
      }.merge(params)

      Net::HTTP.get(request_uri(params, options))
    end

    BATCH_TRANS_NOTIFY_REQUIRED_PARAMS = %w( notify_url account_name detail_data batch_no batch_num batch_fee email )
    def self.batch_trans_notify_url(params, options = {})
      params = Utils.stringify_keys(params)
      check_required_params(params, BATCH_TRANS_NOTIFY_REQUIRED_PARAMS)

      params = {
        'service'        => 'batch_trans_notify',
        '_input_charset' => 'utf-8',
        'partner'        => options[:pid] || Alipay.pid,
        'pay_date'       => Time.now.strftime("%Y%m%d")
      }.merge(params)

      request_uri(params, options).to_s
    end

    CREATE_FOREX_TRADE_WAP_REQUIRED_PARAMS = %w( out_trade_no subject merchant_url currency )
    def self.create_forex_trade_wap_url(params, options = {})
      params = Utils.stringify_keys(params)
      check_required_params(params, CREATE_FOREX_TRADE_WAP_REQUIRED_PARAMS)

      params = {
        'service'        => 'create_forex_trade_wap',
        '_input_charset' => 'utf-8',
        'partner'        => options[:pid] || Alipay.pid,
        'seller_id'      => options[:pid] || Alipay.pid
      }.merge(params)

      request_uri(params, options).to_s
    end

    # Alipay Commerce
    # alipay doc: https://global.alipay.com/service/merchant_QR_Code/15

    CREATE_MERCHANT_QR_CODE_REQUIRED_PARAMS = %w( biz_type biz_data )
    CREATE_MERCHANT_QR_CODE_REQUIRED_BIZ_DATA_PARAMS = %w( secondary_merchant_industry secondary_merchant_id secondary_merchant_name trans_currency currency )
    def self.create_merchant_qr_code(params, options = {})
      params = Utils.stringify_keys(params)
      check_required_params(params, CREATE_MERCHANT_QR_CODE_REQUIRED_PARAMS)
      biz_data = nil

      if params['biz_data'].present?
        params['biz_data'] = Utils.stringify_keys(params['biz_data'])
        check_required_params(params['biz_data'], CREATE_MERCHANT_QR_CODE_REQUIRED_BIZ_DATA_PARAMS)

        data = params.delete('biz_data')
        biz_data = data.map do |key, value|
          "\"#{key}\": \"#{value}\""
        end.join(',')
      end

      biz_data = "{#{biz_data}}"

      params = {
        'service'        => 'alipay.commerce.qrcode.create',
        '_input_charset' => 'utf-8',
        'partner'        => options[:pid] || Alipay.pid,
        'timestamp'      => Time.now.utc.strftime('%Y-%m-%d %H:%M:%S').to_s,
        'biz_data'       => biz_data
      }.merge(params)

      request_uri(params, options).to_s
    end

    ACQUIRER_OVERSEAS_SPOT_REFUND_REQUIRED_PARAMS = %w( partner_trans_id partner_refund_id refund_amount currency )
    def self.acquirer_overseas_spot_refund_url(params, options= {})
      params = Utils.stringify_keys(params)
      check_required_params(params, ACQUIRER_OVERSEAS_SPOT_REFUND_REQUIRED_PARAMS)

      params = {
        'service'        => 'alipay.acquire.overseas.spot.refund',
        '_input_charset' => 'utf-8',
        'partner'        => options[:pid] || Alipay.pid,
        'sign_type' => (options[:sign_type] || Alipay.sign_type),
      }.merge(params)

      request_uri(params, options).to_s
    end

    def self.request_uri(params, options = {})
      uri = URI(GATEWAY_URL)
      uri.query = URI.encode_www_form(sign_params(params, options))
      uri
    end

    def self.sign_params(params, options = {})
      params.merge(
        'sign_type' => (options[:sign_type] || Alipay.sign_type),
        'sign'      => Alipay::Sign.generate(params, options)
      )
    end

    def self.check_required_params(params, names)
      return if !Alipay.debug_mode?

      names.each do |name|
        warn("Alipay Warn: missing required option: #{name}") unless params.has_key?(name)
      end
    end

    def self.check_optional_params(params, names)
      return if !Alipay.debug_mode?

      warn("Alipay Warn: must specify either #{names.join(' or ')}") if names.all? {|name| params[name].nil? }
    end
  end
end
