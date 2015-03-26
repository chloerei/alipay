module Alipay
  module Notify
    def self.verify?(params)
      params = Utils.stringify_keys(params)
      Sign.verify?(params) && verify_notify_id?(params['notify_id'])
    end

    def self.verify_notify_id?(notify_id)
      Net::HTTP.get(URI("https://mapi.alipay.com/gateway.do?service=notify_verify&partner=#{Alipay.pid}&notify_id=#{CGI.escape(notify_id.to_s)}")) == 'true'
    end
  end
end
