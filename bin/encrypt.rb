require 'openssl'
require 'base64'

module HieraEhttp
    class Encrypt
        def initialize cert
            @cert   = cert
            # We like AES 128 in CBC mode
            @cipher = OpenSSL::Cipher.new 'AES-128-CBC'
        end
        
        def encryptPKCS7 value
            "\"ENC[PKCS7," + (Base64.encode64 (OpenSSL::PKCS7::encrypt [@cert], value, @cipher, OpenSSL::PKCS7::BINARY).to_der).delete("\n\r") + "]\""
        end
    end # class Encrypt
end # module HieraEhttp
