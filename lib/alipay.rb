require 'alipay/version'
require 'alipay/utils'
require 'alipay/sign'
require 'alipay/sign/wap'
require 'alipay/service'
require 'alipay/service/wap'
require 'alipay/notify'
require 'alipay/notify/wap'

module Alipay
  @debug_mode = true
  @sign_type = 'MD5'

  class << self
    attr_accessor :pid, :key, :seller_email, :sign_type, :debug_mode

    def debug_mode?
      !!@debug_mode
    end
  end
end
