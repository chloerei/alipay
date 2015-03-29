module Alipay
  module Notify
    module Wap
      def self.verify?(params, options = {})
        params = Utils.stringify_keys(params)
        pid = params[:pid] || Alipay.pid
        notify_id = params['notify_data'].scan(/\<notify_id\>(.*)\<\/notify_id\>/).flatten.first

        Sign::Wap.verify?(params, options) && Notify.verify_notify_id?(pid, notify_id)
      end
    end
  end
end
