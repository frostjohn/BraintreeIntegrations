require 'sinatra'
require 'sinatra/namespace'
require 'braintree'

require_relative 'helpers/pretty_print.rb'

helpers Demo::PrettyPrint

Braintree::Configuration.environment = :sandbox
Braintree::Configuration.merchant_id = 'rqnjssjxyyp8wrxy'
Braintree::Configuration.public_key = 'rwwt62yv2w8s5k2r'
Braintree::Configuration.private_key = '5b47e40ec06459afe5edc24289c0d53f'

get "/" do
	@client_token = Braintree::ClientToken.generate
	erb :index
end

namespace "/dropin" do
  get do
    @client_token = Braintree::ClientToken.generate
    erb :"dropin/index"
  end

  post "/process" do
    result = Braintree::Transaction.sale(
      amount: "100",
      payment_method_nonce: params[:payment_method_nonce]
    )

    if result.success?
      @transaction = result.transaction
      erb :"dropin/process"
    else
      "Payment Failed"
    end
  end
end

namespace "/hostedfields" do
  get do
    @client_token = Braintree::ClientToken.generate
    erb :"hostedfields/index"
  end

  post "/process" do
    result = Braintree::Transaction.sale(
      amount: "150",
      payment_method_nonce: params[:payment_method_nonce]
    )

    if result.success?
      @transaction = result.transaction
      erb :"hostedfields/process"
    else
      "Payment Failed"
    end
  end
end

