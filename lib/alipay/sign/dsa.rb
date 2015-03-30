module Alipay
  module Sign
    class DSA
      def sign(str)
        raise NotImplementedError, '[Alipay] DSA sign is not yet implemented'
      end

      def verify?(str, sign)
        raise NotImplementedError, '[Alipay] DSA verify is not yet implemented'
      end
    end
  end
end
