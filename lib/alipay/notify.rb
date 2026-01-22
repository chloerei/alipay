module Alipay
  module Notify
    def self.verify?(params, options = {})
      params = Utils.stringify_keys(params)
      pid = options[:pid] || Alipay.pid
      Sign.verify?(params, options) && verify_notify_id?(pid, params['notify_id'])
    end

    def self.verify_notify_id?(pid, notify_id)
      uri = URI(Alipay.gateway_url)
      uri.query = URI.encode_www_form(
        'service'   => 'notify_verify',
        'partner'   => pid,
        'notify_id' => notify_id
      )
      Net::HTTP.get(uri) == 'true'
    end
  end
end
