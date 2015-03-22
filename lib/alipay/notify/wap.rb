module Alipay
  module Notify
    module Wap
      def self.verify?(params)
        params = Utils.stringify_keys(params)
        notify_id = params['notify_data'].scan(/\<notify_id\>(.*)\<\/notify_id\>/).flatten.first

        Sign::Wap.verify?(params) && Notify.verify_notify_id?(notify_id)
      end
    end
  end
end
