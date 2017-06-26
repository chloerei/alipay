module Alipay
  class Client
    def initialize(options)
      options = ::Alipay::Utils.stringify_keys(options)
      @url = options['url']
      @app_id = options['app_id']
      @app_private_key = options['app_private_key']
      @format = options['format'] || 'json'
      @charset = options['charset'] || 'utf-8'
      @alipay_public_key = options['alipay_public_key']
      @sign_type = options['sign_type'] || 'RSA2'
    end

    def default_params
      {
        app_id: @app_id,
        charset: @charset,
        sign_type: @sign_type,
        version: '1.0',
        timestamp: Time.now.localtime('+08:00').strftime("%Y-%m-%d %H:%M:%S")
      }
    end

    def request_url(params)
      params = default_params.merge(params)
      params[:sign] = generate_sign(params)

      uri = URI(@url)
      uri.query = URI.encode_www_form(params)
      uri.to_s
    end

    def request_form(params)
      params = default_params.merge(params)
      params[:sign] = generate_sign(params)

      html = %Q(<form id='alipaysubmit' name='alipaysubmit' action='#{@url}' method='POST'>)
      params.each do |key, value|
        html << %Q(<input type='hidden' name='#{key}' value='#{value.gsub("'", "&apos;")}'/>)
      end
      html << "<input type='submit' value='ok' style='display:none'></form>"
      html << "<script>document.forms['alipaysubmit'].submit();</script>"
      html
    end

    def execute(params)
      params = default_params.merge(params)
      params[:sign] = generate_sign(params)

      Net::HTTP.post_form(URI(@url), params).body
    end

    def generate_sign(params)
      string = params.sort.map { |item| item.join('=') }.join('&')

      case @sign_type
      when 'RSA'
        ::Alipay::Sign::RSA.sign(@app_private_key, string)
      when 'RSA2'
        ::Alipay::Sign::RSA2.sign(@app_private_key, string)
      else
        raise "Unsupported sign_type: #{@sign_type}"
      end
    end
  end
end
