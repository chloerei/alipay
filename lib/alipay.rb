require 'alipay/version'
require 'alipay/utils'
require 'alipay/sign'
require 'alipay/service'
require 'alipay/service/wap'
require 'alipay/notify'

module Alipay
  @debug_mode = true

  class << self
    attr_accessor :pid, :key, :seller_email, :debug_mode

    def debug_mode?
      !!@debug_mode
    end
  end
end
