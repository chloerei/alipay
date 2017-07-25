module Alipay
  module Zhima
    module Service
      REQUEST_GATEWAY = "https://openapi.alipay.com/gateway.do"

      def base_params
        base_params = {
          format: ZhimaAuth.configuration.format,
          charset: ZhimaAuth.configuration.charset,
          version: ZhimaAuth.configuration.version
        }
      end

      # 芝麻信用认证初始化
      ZHIMA_CUSTOMER_CERTIFICATION_INITIALIZE_REQUIRED_PARAMS = %w(transaction_id product_code biz_code identity_param)
      def self.zhima_customer_certification_initialize(params, options = {})
        params = Utils.stringify_keys(params)
        Alipay::Service.check_required_params(params, ZHIMA_CUSTOMER_CERTIFICATION_INITIALIZE_REQUIRED_PARAMS)

        app_id = options[:app_id] || Alipay.app_id
        key = options[:key] || Alipay.key
        sign_type = (options[:sign_type] || :rsa2).to_s.upcase

        real_params = base_params.merge({
          'app_id' => app_id,
          'method' => 'zhima.customer.certification.initialize',
          'sign_type' => sign_type,
          'timestamp' => Time.now.strftime("%Y-%m-%d %H:%M:%S"),
          'biz_content' => params.to_json
        })

        signed_params = real_params.merge("sign" => get_sign_by_type(real_params, key, sign_type))

        uri = URI(::Alipay::Zhima::Service::REQUEST_GATEWAY)
        uri.query = URI.encode_www_form(signed_params)

        Net::HTTP.get(uri)
      end

      # 芝麻信用开始认证
      ZHIMA_CUSTOMER_CERTIFICATION_CERTIFY_REQUIRED_PARAMS = %w(biz_no)
      def zhima_customer_certification_certify(params, options = {})
        params = Utils.stringify_keys(params)
        Alipay::Service.check_required_params(params, ZHIMA_CUSTOMER_CERTIFICATION_CERTIFY_REQUIRED_PARAMS)

        app_id = options[:app_id] || Alipay.app_id
        key = options[:key] || Alipay.key
        sign_type = (options[:sign_type] || :rsa2).to_s.upcase

        real_params = base_params.merge({
          'app_id' => app_id,
          'method' => 'zhima.customer.certification.certify',
          'sign_type' => sign_type,
          'timestamp' => Time.now.strftime("%Y-%m-%d %H:%M:%S")
        })

        real_params["return_url"] = params["return_url"] unless params["return_url"].nil?
        params.delete('return_url')

        real_params["biz_content"] = params.to_json

        signed_params = real_params.merge("sign" => get_sign_by_type(real_params, key, sign_type))

        uri = URI(::Alipay::Zhima::Service::REQUEST_GATEWAY)
        uri.query = URI.encode_www_form(signed_params)

        uri.to_s
      end

      # 芝麻认证查询
      ZHIMA_CUSTOMER_CERTIFICATION_QUERY_REQUIRED_PARAMS = %w(biz_no)
      def zhima.customer_certification_query(params, options = {})
        params = Utils.stringify_keys(params)
        Alipay::Service.check_required_params(params, ZHIMA_CUSTOMER_CERTIFICATION_QUERY_REQUIRED_PARAMS)

        app_id = options[:app_id] || Alipay.app_id
        key = options[:key] || Alipay.key
        sign_type = (options[:sign_type] || :rsa2).to_s.upcase

        real_params = base_params.merge({
          'app_id' => app_id,
          'method' => 'zhima.customer.certification.query',
          'sign_type' => sign_type,
          'timestamp' => Time.now.strftime("%Y-%m-%d %H:%M:%S"),
          'biz_content' => params.to_json
        })

        signed_params = real_params.merge("sign" => get_sign_by_type(real_params, key, sign_type))

        uri = URI(::Alipay::Zhima::Service::REQUEST_GATEWAY)
        uri.query = URI.encode_www_form(signed_params)

        Net::HTTP.get(uri)
      end

      # 芝麻信用评分
      ZHIMA_CREDIT_SCORE_BRIEF_GET_REQUIRED_PARAMS = %w(transaction_id product_code cert_type admittance_score cert_no name)
      def self.zhima_credit_score_brief_get(params, options = {})
        params = Utils.stringify_keys(params)
        Alipay::Service.check_required_params(params, ZHIMA_CREDIT_SCORE_BRIEF_GET_REQUIRED_PARAMS)

        app_id = options[:app_id] || Alipay.app_id
        key = options[:key] || Alipay.key
        sign_type = (options[:sign_type] || :rsa2).to_s.upcase

        real_params = base_params.merge({
          'app_id' => app_id,
          'method' => 'zhima.credit.score.brief.get',
          'sign_type' => sign_type,
          'timestamp' => Time.now.strftime("%Y-%m-%d %H:%M:%S"),
          'biz_content' => params.to_json
        })

        signed_params = real_params.merge("sign" => get_sign_by_type(real_params, key, sign_type))

        uri = URI(::Alipay::Zhima::Service::REQUEST_GATEWAY)
        uri.query = URI.encode_www_form(signed_params)

        Net::HTTP.get(uri)
      end

      # 信用借还订单创建
      ZHIMA_MERCHANT_ORDER_RENT_CREATE_REQUIRED_PARAMS = %w(invoke_type invoke_return_url out_order_no product_code goods_name rent_unit rent_amount deposit_amount deposit_state)
      def self.zhima_merchant_order_rent_create(params, options = {})
        params = Utils.stringify_keys(params)
        Alipay::Service.check_required_params(params, ZHIMA_MERCHANT_ORDER_RENT_CREATE_REQUIRED_PARAMS)

        app_id = options[:app_id] || Alipay.app_id
        key = options[:key] || Alipay.key
        sign_type = (options[:sign_type] || :rsa2).to_s.upcase

        real_params = base_params.merge({
          'app_id' => app_id,
          'method' => 'zhima.merchant.order.rent.create',
          'sign_type' => sign_type,
          'timestamp' => Time.now.strftime("%Y-%m-%d %H:%M:%S")
        })

        real_params["return_url"] = params["return_url"] unless params["return_url"].nil?
        params.delete('return_url')

        real_params["biz_content"] = params.to_json

        signed_params = real_params.merge("sign" => get_sign_by_type(real_params, key, sign_type))

        uri = URI(::Alipay::Zhima::Service::REQUEST_GATEWAY)
        uri.query = URI.encode_www_form(signed_params)

        uri.to_s
      end

      # 信用借还订单查询
      ZHIMA_MERCHANT_ORDER_RENT_QUERY_REQUIRED_PARAMS = %w(out_order_no product_code)
      def self.zhima_merchant_order_rent_query(params, options = {})
        params = Utils.stringify_keys(params)
        Alipay::Service.check_required_params(params, ZHIMA_MERCHANT_ORDER_RENT_QUERY_REQUIRED_PARAMS)

        app_id = options[:app_id] || Alipay.app_id
        key = options[:key] || Alipay.key
        sign_type = (options[:sign_type] || :rsa2).to_s.upcase

        real_params = base_params.merge({
          'app_id' => app_id,
          'method' => 'zhima.merchant.order.rent.query',
          'sign_type' => sign_type,
          'timestamp' => Time.now.strftime("%Y-%m-%d %H:%M:%S"),
          'biz_content' => params.to_json
        })

        signed_params = real_params.merge("sign" => get_sign_by_type(real_params, key, sign_type))

        uri = URI(::Alipay::Zhima::Service::REQUEST_GATEWAY)
        uri.query = URI.encode_www_form(signed_params)

        Net::HTTP.get(uri)
      end

      # 信用借还订单完结
      ZHIMA_MERCHANT_ORDER_RENT_COMPLETE_REQUIRED_PARAMS = %w(order_no product_code restore_time pay_amount_type pay_amount)
      def self.zhima_merchant_order_rent_complete(params, options = {})
        params = Utils.stringify_keys(params)
        Alipay::Service.check_required_params(params, ZHIMA_MERCHANT_ORDER_RENT_COMPLETE_REQUIRED_PARAMS)

        app_id = options[:app_id] || Alipay.app_id
        key = options[:key] || Alipay.key
        sign_type = (options[:sign_type] || :rsa2).to_s.upcase

        real_params = base_params.merge({
          'app_id' => app_id,
          'method' => 'zhima.merchant.order.rent.complete',
          'sign_type' => sign_type,
          'timestamp' => Time.now.strftime("%Y-%m-%d %H:%M:%S"),
          'biz_content' => params.to_json
        })

        signed_params = real_params.merge("sign" => get_sign_by_type(real_params, key, sign_type))

        uri = URI(::Alipay::Zhima::Service::REQUEST_GATEWAY)
        uri.query = URI.encode_www_form(signed_params)

        Net::HTTP.get(uri)
      end

      # 信用借还订单撤销
      ZHIMA_MERCHANT_ORDER_RENT_CANCEL_REQUIRED_PARAMS = %w(order_no product_code)
      def self.zhima_merchant_order_rent_cancel(params, options = {})
        params = Utils.stringify_keys(params)
        Alipay::Service.check_required_params(params, ZHIMA_MERCHANT_ORDER_RENT_CANCEL_REQUIRED_PARAMS)

        app_id = options[:app_id] || Alipay.app_id
        key = options[:key] || Alipay.key
        sign_type = (options[:sign_type] || :rsa2).to_s.upcase

        real_params = base_params.merge({
          'app_id' => app_id,
          'method' => 'zhima.merchant.order.rent.cancel',
          'sign_type' => sign_type,
          'timestamp' => Time.now.strftime("%Y-%m-%d %H:%M:%S"),
          'biz_content' => params.to_json
        })

        signed_params = real_params.merge("sign" => get_sign_by_type(real_params, key, sign_type))

        uri = URI(::Alipay::Zhima::Service::REQUEST_GATEWAY)
        uri.query = URI.encode_www_form(signed_params)

        Net::HTTP.get(uri)
      end


      # 信用借还订单修改
      ZHIMA_MERCHANT_ORDER_RENT_MODIFY_REQUIRED_PARAMS = %w(order_no product_code)
      def self.zhima_merchant_order_rent_modify(params, options = {})
        params = Utils.stringify_keys(params)
        Alipay::Service.check_required_params(params, FUND_TRANS_TOACCOUNT_TRANSFER_REQUIRED_PARAMS)

        app_id = options[:app_id] || Alipay.app_id
        key = options[:key] || Alipay.key
        sign_type = (options[:sign_type] || :rsa2).to_s.upcase

        real_params = base_params.merge({
          'app_id' => app_id,
          'method' => 'zhima.merchant.order.rent.modify',
          'sign_type' => sign_type,
          'timestamp' => Time.now.strftime("%Y-%m-%d %H:%M:%S"),
          'biz_content' => params.to_json
        })

        signed_params = params.merge("sign" => get_sign_by_type(real_params, key, sign_type))

        uri = URI(::Alipay::Zhima::Service::REQUEST_GATEWAY)
        uri.query = URI.encode_www_form(signed_params)

        Net::HTTP.get(uri)
      end

      # 信用借还借用实体数据上传
      ZHIMA_MERCHANT_BORROW_ENTITY_UPLOAD_REQUIRED_PARAMS= %w(product_code category_code entity_code longitude latitude entity_name collect_rent can_borrow can_borrow_cnt total_borrow_cnt upload_time)
      def zhima_merchant_borrow_entity_upload(params, options = {})
        params = Utils.stringify_keys(params)
        Alipay::Service.check_required_params(params, ZHIMA_MERCHANT_BORROW_ENTITY_UPLOAD_REQUIRED_PARAMS)

        app_id = options[:app_id] || Alipay.app_id
        key = options[:key] || Alipay.key
        sign_type = (options[:sign_type] || :rsa2).to_s.upcase

        real_params = base_params.merge({
          'app_id' => app_id,
          'method' => 'zhima.merchant.borrow.entity.upload',
          'sign_type' => sign_type,
          'timestamp' => Time.now.strftime("%Y-%m-%d %H:%M:%S"),
          'biz_content' => params.to_json
        })

        signed_params = params.merge("sign" => get_sign_by_type(real_params, key, sign_type))

        uri = URI(::Alipay::Zhima::Service::REQUEST_GATEWAY)
        uri.query = URI.encode_www_form(signed_params)

        Net::HTTP.get(uri)
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

    end
  end
end
