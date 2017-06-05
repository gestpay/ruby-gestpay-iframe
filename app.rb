require 'sinatra/base'
require 'pp'

require_relative 'constants/constants'
require_relative 'gestpay_ws_crypt_decrypt/ws_crypt_decrypt'

module RubyGestpayIFrame

  class App < Sinatra::Application

    # Initialization of App class. Define some common variables
    def initialize
      super
      # this is our Gestpay WsCryptDecrypt webservice.
      @gestpay = Gestpay::WsCryptDecrypt.new RubyGestpayIFrame::SHOP_LOGIN, :test

      # used in templates to determine which js should be called.
      @gestpay_js_url = if RubyGestpayIFrame::ENVIRONMENT == :test
                          'https://testecomm.sella.it/pagam/JavaScript/js_GestPay.js'
                        else
                          'https://ecomm.sella.it/pagam/JavaScript/js_GestPay.js'
                        end

      # used in .erb files
      @is_test_env = RubyGestpayIFrame::ENVIRONMENT == :test

      @shop_login = RubyGestpayIFrame::SHOP_LOGIN
    end

    # displays the home page
    get '/' do
      erb :index
    end

    # after selecting an item, you'll be redirected to the page where you can actually perform the payment.
    # the first step is to create an encrypt_request, then this request is passed to the template file.
    # the template file will use the encrypt_request and the shop_login to create the hidden iframe form, for paying.
    post '/pay' do
      item = params['item']
      amount = params['price']
      logger.info "received request for item #{item} with price #{amount}..."

      encrypt_request = {
          shop_login: RubyGestpayIFrame::SHOP_LOGIN,
          amount: amount,
          uic_code: '242'
      }
      encrypt_response = @gestpay.encrypt encrypt_request
      if encrypt_response.dig(:error_code) != "0"
        raise "Error during Encrypt, errorcode:"+encrypt_response.dig(:error_code)+ " errorDescription:" + encrypt_response.dig(:error_description)
      end
      crypted_string = encrypt_response.dig(:crypt_decrypt_string)

      erb :pay, :locals => {
          :item => item,
          :amount => amount,
          :crypted_string => crypted_string,
          :pares => ''
      }
    end

    # If the credit card is 3D secure, the browser will be redirected to the card circuit to perform the authentication.
    # after this, the system will redirect the user to this page with the PaRes parameter, used to authenticate the
    # original payment.
    post '/pay-secure' do
      pares = params['PaRes']
      logger.info "pares: #{pares}"

      erb :pay_secure, :locals => {
          :pares => pares
      }

    end

    # This endpoint is called when the payment is completed. it will decypher the encrypted string coming from Gestpay,
    # that contains the encrypted payment outcome. Then the output is shown in page.
    get '/response' do
      shop_login = params['a']
      crypted_string = params['b']

      puts "Received message from Gestpay: #{shop_login} is here"

      result = @gestpay.decrypt :shop_login => shop_login, 'CryptedString' => crypted_string

      puts result.inspect

      erb :response, :locals => {
          :result => result,
          :result_ruby => result.pretty_inspect
      }
    end

    # start the server if ruby file executed directly
    run! if app_file == $0
  end
end
