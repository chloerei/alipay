module Alipay
  module Utils
    def self.stringify_keys(hash)
      new_hash = {}
      hash.each do |key, value|
        new_hash[(key.to_s rescue key) || key] = value
      end
      new_hash
    end

    # 退款批次号，支付宝通过此批次号来防止重复退款操作，所以此号生成后最好直接保存至数据库，不要在显示页面的时候生成
    # 共 24 位(8 位当前日期 + 9 位纳秒 + 1 位随机数)
    def self.generate_batch_no
      t = Time.now
      batch_no = t.strftime('%Y%m%d%H%M%S') + t.nsec.to_s
      batch_no.ljust(24, rand(10).to_s)
    end

    # get app_cert_sn
    def self.get_cert_sn(str, match_algo = false)
      return nil if str.nil?
      certificate = OpenSSL::X509::Certificate.new(str)
      if match_algo
        begin
          return unless certificate.public_key.is_a?(OpenSSL::PKey::RSA)
        rescue
          return
        end
      end
      issuer_arr = OpenSSL::X509::Name.new(certificate.issuer).to_a
      issuer = issuer_arr.reverse.map { |item| item[0..1].join('=') }.join(',')
      serial = OpenSSL::BN.new(certificate.serial).to_s
      OpenSSL::Digest::MD5.hexdigest(issuer + serial)
    end

    # get alipay_root_cert_sn
    def self.get_root_cert_sn(str)
      return nil if str.nil?
      arr = str.scan(/-----BEGIN CERTIFICATE-----[\s\S]*?-----END CERTIFICATE-----/)
      arr_sn = []
      arr.each do |item|
        sn = get_cert_sn(item, true)
        unless sn.nil?
          arr_sn.push(sn)
        end
      end
      arr_sn.join('_')
    end
  end
end
