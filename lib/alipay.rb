require "alipay/version"
require 'alipay/utils'
require 'alipay/sign'
require 'alipay/service'
require 'alipay/notify'

module Alipay
  class << self
    attr_accessor :pid
    attr_accessor :key
    attr_accessor :seller_email
    attr_accessor :rsa_private_key
    attr_accessor :rsa_alipay_public_key
  end
end
