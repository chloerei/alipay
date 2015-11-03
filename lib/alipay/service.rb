module Alipay
  module Service
    GATEWAY_URL = 'https://mapi.alipay.com/gateway.do'

    CREATE_PARTNER_TRADE_BY_BUYER_REQUIRED_PARAMS = %w( out_trade_no subject logistics_type logistics_fee logistics_payment price quantity )
    # alipayescow
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
    # alipaydualfun
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
    # direct
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
    # direct wap
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
    # 支付宝即时到帐批量退款有密接口(此为异步接口，有密指通过此接口打开 url 后需要用户输入支付宝的支付密码进行退款)
    def self.refund_fastpay_by_platform_pwd_url(params, options = {})
      params = Utils.stringify_keys(params)
      check_required_params(params, CREATE_REFUND_URL_REQUIRED_PARAMS)

      data = params.delete('data')
      detail_data = data.map do|item|
        item = Utils.stringify_keys(item)
        "#{item['trade_no']}^#{item['amount']}^#{item['reason']}"
      end.join('#')

      params = {
        'service'        => 'refund_fastpay_by_platform_pwd',  # 接口名称
        '_input_charset' => 'utf-8',
        'partner'        => options[:pid] || Alipay.pid,
        'seller_user_id' => options[:pid] || Alipay.pid,
        'refund_date'    => Time.now.strftime('%Y-%m-%d %H:%M:%S'), # 申请退款时间
        'batch_num'      => data.size,                              # 总笔数
        'detail_data'    => detail_data                             # 转换后的单笔数据集字符串
      }.merge(params)

      request_uri(params, options).to_s
    end

    CREATE_FOREX_SINGLE_REFUND_URL_REQUIRED_PARAMS = %w( out_return_no out_trade_no return_amount currency reason )
    # 支付宝境外收单单笔退款接口
    # out_return_no 退款流水单号
    # out_trade_no 交易创建时的订单号
    # return_amount 退款金额
    # currency 退款币种，与交易创建时的币种一致
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

    # 查询指定时间段内的账单，需要签约 "账单明细分页查询接口"
    def self.account_page_query(params, options = {})
      params = {
        service: 'account.page.query',
        _input_charset: 'utf-8',
        partner: options[:pid] || Alipay.pid,
      }.merge(params)

      Net::HTTP.get(request_uri(params, options))
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
