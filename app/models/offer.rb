class Offer
  def self.all(params)
    request = Request.new params
    request.valid? ? request.to_hash['offers'] : []
  end
end
