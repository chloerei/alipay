# 配合支付宝使用RSA密钥

[English](rsa_key_en.md)

## 导航
* [生成应用密钥](#生成应用密钥)
* [验证参数](#验证参数)
* [补充格式到支付宝公钥](#补充格式到支付宝公钥)

### 生成应用密钥
#### 在 Ruby 下生成 RSA2 密钥
这里会示范在 Ruby 环境下生成RSA2密钥。支付宝推荐使用RSA2密钥来验证。
```ruby
require 'openssl'

@app_key = OpenSSL::PKey::RSA.new(2048)
```
#### 保存密钥
你可以使用以下任一方式来保存你的私钥和公钥

将私钥保存到字符串
```ruby
app_private_key = @app_key.to_s
```

将私钥保存为证书文件
```ruby
open 'private_key.pem', 'w' do |io| io.write @app_key.to_pem end
```

将公钥保存到字符串
```ruby
app_public_key = @app_key.public_key.to_s
```
将公钥保存为证书文件
```ruby
open 'public_key.pem', 'w' do |io| io.write @app_key.public_key.to_pem end
```

#### 提取钥匙内容
你需要给支付宝提供你所先前生成的公钥内容。但是提供给支付宝之前需要对 Ruby 生成的公钥进行格式清理。清理完后，将清理好的公钥内容提供给支付宝即可。
```ruby
key_content = app_public_key.gsub(/(-----BEGIN PUBLIC KEY-----)|(-----END PUBLIC KEY-----)|(\n)/, "")
puts key_content
# => 'MII0ey6QDZLB69i0e5Q0....'
```

### 验证参数
当你提交你的应用公钥给支付宝后，有一个可选的步骤是验证你的公钥的有效性。支付宝会提供一个参数让你使用你的私钥签名。把签名结果粘贴到支付宝后，支付宝会使用你上传的公钥来解密验证。
```ruby
# validate params "a=123"
Base64.strict_encode64(@app_key.sign('sha256', "a=123"))
# => 'FokDu5uwgmNG2O/cb0QYD....'
```

### 补充格式到支付宝公钥
当你上传好你的公钥后，支付宝会提供他们的公钥给你的应用来验证回调的内容有效性。但是他们提供公钥不带格式，所以 Ruby 的 OpneSSL 程序库可能无法识别。你可以使用以下运行脚本，将格式补充到支付宝所提供的公钥。

```ruby
pub_key = "MIIBI...HpwIDAQAB"
pub_key.tap do |key|
  key.scan(/.{64}/).join("\n")
  key.insert(0, "-----BEGIN PUBLIC KEY-----\n")
  key.insert(-1, "\n-----END PUBLIC KEY-----\n")
end
# => "-----BEGIN PUBLIC KEY-----\nMIIBI...\n-----END PUBLIC KEY-----\n"
```

