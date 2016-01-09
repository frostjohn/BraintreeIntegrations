require 'sinatra'
require 'braintree'
require_relative 'helpers/pretty_print.rb'

helpers Demo::PrettyPrint

Braintree::Configuration.environment = :sandbox
Braintree::Configuration.merchant_id = 'y96myt85ndr9mz2k'
Braintree::Configuration.public_key = 'xdf47q5m2cvp26gg'
Braintree::Configuration.private_key = 'a34e870aa81c424d4cb9b54bacfd845a'

get "/" do
	@client_token = Braintree::ClientToken.generate
	erb :index
end

post "/process" do
  result = Braintree::Transaction.sale(
    amount: "100",
    payment_method_nonce: params[:payment_method_nonce]
  )

  if result.success?
    @transaction = result.transaction
    erb :process
  else
    "Payment Failed"
  end  
end
