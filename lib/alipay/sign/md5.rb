require 'digest/md5'

module Alipay
  module Sign
    class MD5
      def self.sign(str)
        Digest::MD5.hexdigest(str)
      end

      def self.verify?(str, sign)
        sign == sign(str)
      end
    end
  end
end
