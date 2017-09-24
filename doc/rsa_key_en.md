# RSA Key for Alipay

[中文](rsa_key_cn.md)

## Table of Contents

* [Generate Application Key](#generate-application-key)
  * [Generate RSA2 Keypair in Ruby](#generate-rsa2-keypair-in-ruby)
  * [Saving Key](#saving-key)
  * [Extract Key Content](#extract-key-content)
* [Signing Parameters](#signing-parameters)
* [Formatting the Public Key from Alipay](#formatting-the-public-key-from-alipay)

### Generate Application Key
#### Generate RSA2 Keypair in Ruby
This example creates a 2048 bits RSA2 key. It is recommended by Alipay that
you use a RSA2 key.
```ruby
require 'openssl'

@app_key = OpenSSL::PKey::RSA.new(2048)
```
#### Saving Key
You can save your private and public key as any of two formats. As long as it can be loaded into the program.

Saving Private Key to String
```ruby
app_private_key = @app_key.to_s
```

Saving Private Key to File
```ruby
open 'private_key.pem', 'w' do |io| io.write @app_key.to_pem end
```

Saving Public Key to String
```ruby
app_public_key = @app_key.public_key.to_s
```

Saving Public Key to File
```ruby
open 'public_key.pem', 'w' do |io| io.write @app_key.public_key.to_pem end
```

#### Extract Key Content
You will need to submit the application public key that you just created
to Alipay. However, you will need to strip the header, footer, and new line
characters from the key and just submit the key content to Alipay.
```ruby
key_content = app_public_key.gsub(/(-----BEGIN PUBLIC KEY-----)|(-----END PUBLIC KEY-----)|(\n)/, "")
puts key_content
# => 'MII0ey6QDZLB69i0e5Q0....'
```

### Signing Parameters
After you submit your application's public key to Alipay. There is an optional
step to validate the public key that you just uploaded by signing a parameter
provided by Alipay.

```ruby
# validate params "a=123"
Base64.strict_encode64(@app_key.sign('sha256', "a=123"))
# => 'FokDu5uwgmNG2O/cb0QYD....'
```

### Formatting the Public Key from Alipay
The public key from Alipay does not contain any formatting. Ruby's OpenSSL
library cannot import/read the public key without proper formatting. To add
formatting back, run the following script.

```ruby
pub_key = "MIIBI...HpwIDAQAB"
pub_key.tap do |key|
  key.scan(/.{64}/).join("\n")
  key.insert(0, "-----BEGIN PUBLIC KEY-----\n")
  key.insert(-1, "\n-----END PUBLIC KEY-----\n")
end
# => "-----BEGIN PUBLIC KEY-----\nMIIBI...\n-----END PUBLIC KEY-----\n"
```

