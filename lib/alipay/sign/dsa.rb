module Alipay
  module Sign
    class DSA
      def self.sign(string)
        raise NotImplementedError, '[Alipay] DSA sign is not implemented'
      end

      def self.verify?(string, sign)
        raise NotImplementedError, '[Alipay] DSA verify is not implemented'
      end
    end
  end
end
