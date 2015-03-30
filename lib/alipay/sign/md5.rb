require 'digest/md5'

module Alipay
  module Sign
    class MD5
      def self.sign(string)
        Digest::MD5.hexdigest(string)
      end

      def self.verify?(string, sign)
        sign == sign(string)
      end
    end
  end
end
