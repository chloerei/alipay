require 'digest/md5'

module Alipay
  module Sign
    class MD5
      def self.sign(key, string)
        Digest::MD5.hexdigest("#{string}#{key}")
      end

      def self.verify?(key, string, sign)
        sign == sign(key, string)
      end
    end
  end
end
