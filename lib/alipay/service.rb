require 'cgi'
require 'open-uri'

module Alipay
  module Service
    GATEWAY_URL = 'https://mapi.alipay.com/gateway.do'

    CREATE_PARTNER_TRADE_BY_BUYER_REQUIRED_OPTIONS = %w( service partner _input_charset out_trade_no subject payment_type logistics_type logistics_fee logistics_payment seller_email price quantity )
    # alipayescow
    def self.create_partner_trade_by_buyer_url(options)
      options = {
        'service'        => 'create_partner_trade_by_buyer',
        '_input_charset' => 'utf-8',
        'partner'        => Alipay.pid,
        'seller_email'   => Alipay.seller_email,
        'payment_type'   => '1'
      }.merge(Utils.stringify_keys(options))

      check_required_options(options, TRADE_CREATE_BY_BUYER_REQUIRED_OPTIONS)

      "#{GATEWAY_URL}?#{query_string(options)}"
    end

    TRADE_CREATE_BY_BUYER_REQUIRED_OPTIONS = %w( service partner _input_charset out_trade_no subject payment_type logistics_type logistics_fee logistics_payment seller_email price quantity )
    # alipaydualfun
    def self.trade_create_by_buyer_url(options = {})
      options = {
        'service'        => 'trade_create_by_buyer',
        '_input_charset' => 'utf-8',
        'partner'        => Alipay.pid,
        'seller_email'   => Alipay.seller_email,
        'payment_type'   => '1'
      }.merge(Utils.stringify_keys(options))

      check_required_options(options, TRADE_CREATE_BY_BUYER_REQUIRED_OPTIONS)

      "#{GATEWAY_URL}?#{query_string(options)}"
    end

    CREATE_DIRECT_PAY_BY_USER_REQUIRED_OPTIONS = %w( service partner _input_charset out_trade_no subject payment_type seller_email )
    # direct
    def self.create_direct_pay_by_user_url(options)
      options = {
        'service'        => 'create_direct_pay_by_user',
        '_input_charset' => 'utf-8',
        'partner'        => Alipay.pid,
        'seller_email'   => Alipay.seller_email,
        'payment_type'   => '1'
      }.merge(Utils.stringify_keys(options))

      check_required_options(options, CREATE_DIRECT_PAY_BY_USER_REQUIRED_OPTIONS)

      if options['total_fee'].nil? and (options['price'].nil? || options['quantity'].nil?)
        warn("Ailpay Warn: total_fee or (price && quantiry) must have one")
      end

      "#{GATEWAY_URL}?#{query_string(options)}"
    end

    CREATE_REFUND_URL_REQUIRED_OPTIONS = %w( batch_no data notify_url )
    def self.create_refund_url(options)
      options = Utils.stringify_keys(options)
      check_required_options(options, CREATE_REFUND_URL_REQUIRED_OPTIONS)

      data = options.delete('data')
      detail_data = data.map{|item| "#{item['trade_no']}^#{item['amount']}^#{item['reason']}"}.join('#')

      options = {
        'service'        => 'refund_fastpay_by_platform_pwd',  # 接口名称
        '_input_charset' => 'utf-8',
        'partner'        => Alipay.pid,
        'seller_email'   => Alipay.seller_email,
        'refund_date'    => Time.now.strftime('%Y-%m-%d %H:%M:%S'), # 申请退款时间
        'batch_num'      => data.size,                              # 总笔数
        'detail_data'    => detail_data                             # 转换后的单笔数据集字符串
      }.merge(options)

      "#{GATEWAY_URL}?#{query_string(options)}"
    end

    SEND_GOODS_CONFIRM_BY_PLATFORM_REQUIRED_OPTIONS = %w( service partner _input_charset trade_no logistics_name )
    def self.send_goods_confirm_by_platform(options)
      options = {
        'service'        => 'send_goods_confirm_by_platform',
        'partner'        => Alipay.pid,
        '_input_charset' => 'utf-8'
      }.merge(Utils.stringify_keys(options))

      check_required_options(options, SEND_GOODS_CONFIRM_BY_PLATFORM_REQUIRED_OPTIONS)

      if options['transport_type'].nil? and options['create_transport_type'].nil?
        warn("Ailpay Warn: transport_type or create_transport_type must have one")
      end

      open("#{GATEWAY_URL}?#{query_string(options)}").read
    end

    def self.query_string(options)
      options.merge('sign_type' => 'MD5', 'sign' => Alipay::Sign.generate(options)).map do |key, value|
        "#{CGI.escape(key.to_s)}=#{CGI.escape(value.to_s)}"
      end.join('&')
    end

    def self.check_required_options(options, names)
      names.each do |name|
        warn("Ailpay Warn: missing required option: #{name}") unless options.has_key?(name)
      end
    end
  end
end
