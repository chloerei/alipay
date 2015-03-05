require 'alipay/version'
require 'alipay/utils'
require 'alipay/sign'
require 'alipay/service'
require 'alipay/service/wap'
require 'alipay/notify'

module Alipay
  class << self
    attr_accessor :pid
    attr_accessor :key
    attr_accessor :seller_email
    attr_writer :debug_mode

    def debug_mode?
      @debug_mode.nil? ? true : !!@debug_mode
    end
  end
end
