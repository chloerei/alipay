module Alipay
  module Open
    class Configuration
      attr_accessor :format, :charset, :version
      def initialize
        @format = "JSON"
        @charset = "utf-8"
        @version = "1.0"
      end
    end
  end
end
