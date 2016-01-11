require 'net/http'
require 'cgi'
require 'alipay/version'
require 'alipay/utils'
require 'alipay/sign'
require 'alipay/sign/md5'
require 'alipay/sign/rsa'
require 'alipay/sign/dsa'
require 'alipay/service'
require 'alipay/notify'
require 'alipay/wap/service'
require 'alipay/wap/notify'
require 'alipay/wap/sign'
require 'alipay/mobile/service'
require 'alipay/mobile/sign'

module Alipay
  @debug_mode = true
  @sign_type = 'MD5'

  class << self
    attr_accessor :pid, :key, :sign_type, :debug_mode, :public_key

    def debug_mode?
      !!@debug_mode
    end
  end
end
