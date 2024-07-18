require 'httparty'

require_relative '../../application/interfaces/gateways/products'


class HTTPartyProductsGateway < ProductsGateway
  def initialize(base_url, session)
    @base_url = base_url
    @session = session
  end

  def retrieve(product_id)
    url = "#{@base_url}/products/#{product_id}"
    response = request("get", url)

    begin
      RetrieveProductOutputDTO.new(
        response["id"],
        response["title"],
        response["price"]
      )
    rescue KeyError => e
      raise ProductsGatewayError.new(response.to_s), e.message
    end
  end

  private

  def request(method, url)
    options = { headers: { "Content-Type" => "application/json" } }
    response = @session.send(method, url, options)

    raise ProductsGatewayError, response.parsed_response.to_s if response.code != 200

    response.parsed_response
  end
end

