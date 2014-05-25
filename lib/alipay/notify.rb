module Alipay
  module Notify
    module Wap
      def self.verify?(params)
        params = Utils.stringify_keys(params)
        Sign::Wap.verify?(params) && Notify.verify_notify_id?(params['notify_id'])
      end
    end

    def self.verify?(params)
      params = Utils.stringify_keys(params)
      Sign.verify?(params) && verify_notify_id?(params['notify_id'])
    end

    private

    def self.verify_notify_id?(notify_id)
      open("https://mapi.alipay.com/gateway.do?service=notify_verify&partner=#{Alipay.pid}&notify_id=#{CGI.escape notify_id.to_s}").read == 'true'
    end
  end
end
