module Alipay
  module Wap
    module Notify
      def self.verify?(params, options = {})
        params = Utils.stringify_keys(params)
        pid = params[:pid] || Alipay.pid
        notify_id = params['notify_data'].scan(/\<notify_id\>(.*)\<\/notify_id\>/).flatten.first

        Sign.verify?(params, options) && ::Alipay::Notify.verify_notify_id?(pid, notify_id)
      end
    end
  end
end
