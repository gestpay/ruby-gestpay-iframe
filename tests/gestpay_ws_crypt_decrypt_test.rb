require "test/unit"

require_relative "../gestpay_ws_crypt_decrypt/ws_crypt_decrypt"


module Gestpay

  class GestpayWsCryptDecryptTest < Test::Unit::TestCase

    def setup
      @shop_login = "GESPAY65987"
    end

    def test_encrypt

      gestpay = WsCryptDecrypt.new @shop_login, :test

      encrypt_request = {
          shop_login: @shop_login,
          uic_code: '242',
          amount: '73.23'
      }

      encrypt_response = gestpay.encrypt encrypt_request

      assert_not_nil encrypt_response

      puts encrypt_response
      assert_equal '0', encrypt_response.dig(:error_code)

    end

    def test_decrypt

      gestpay = WsCryptDecrypt.new @shop_login, :test

      decrypt_request = {
          shop_login: @shop_login,
          'CryptedString' => 'ABCDEFGHIJKLMNO'
      }

      decrypt_response = gestpay.decrypt decrypt_request

      puts decrypt_response

      assert_not_nil decrypt_response
      assert_equal 'KO', decrypt_response.dig(:transaction_result)
    end
  end
end