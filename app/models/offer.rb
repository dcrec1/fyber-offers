class Offer
  def self.all(params)
    request = Request.new params
    request.valid? ? JSON.parse(request.response)['offers'] : []
  end
end
