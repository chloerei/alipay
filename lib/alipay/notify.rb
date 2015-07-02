module Alipay
  module Notify
    def self.verify?(params, options = {})
      params = Utils.stringify_keys(params)
      pid = options[:pid] || Alipay.pid
      Sign.verify?(params, options) && verify_notify_id?(pid, params['notify_id'])
    end

    def self.verify_notify_id?(pid, notify_id)
      uri = URI("https://mapi.alipay.com/gateway.do")
      uri.query = URI.encode_www_form(
        'service'   => 'notify_verify',
        'partner'   => pid,
        'notify_id' => notify_id
      )
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)
      response.body == 'true'
    end
  end
end
