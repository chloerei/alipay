module Alipay
  module Notify
    def self.verify?(params, options = {})
      params = Utils.stringify_keys(params)
      pid = options[:pid] || Alipay.pid
      Sign.verify?(params, options) && verify_notify_id?(pid, params['notify_id'])
    end

    def self.verify_notify_id?(pid, notify_id)
      if (Alipay.transport == 'https')
        uri = URI('https://mapi.alipay.com/gateway.do')
        uri.query = URI.encode_www_form(
            'service' => 'notify_verify',
            'partner' => pid,
            'notify_id' => notify_id
        )
      else
        uri = URI('http://notify.alipay.com/trade/notify_query.do')
        uri.query = URI.encode_www_form(
            'partner' => pid,
            'notify_id' => notify_id
        )
      end
      Net::HTTP.get(uri) == 'true'
    end
  end
end
