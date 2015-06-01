class Offer
  class Params < Hash
    def to_hash
      request_params.merge hashkey: hashkey 
    end

    private

    def request_params
      merge(Rails.application.secrets.fyber.slice('appid', 'ip', 'device_id', 'idfa')).merge timestamp: Time.now.to_i, apple_idfa_tracking_enabled: false, os_version: '6.0', offer_types: 112, locale: 'de'
    end

    def hashkey
      Digest::SHA1.hexdigest(request_params.to_a.sort { |a, b| a[0].to_s <=> b[0].to_s }.map { |pair| "#{pair[0]}=#{pair[1]}" }.join("&") + "&#{Rails.application.secrets.fyber['api_key']}")
    end
  end

  def self.all(params)
    JSON.parse(RestClient.get("http://api.sponsorpay.com/feed/v1/offers.json", params: Params[params].to_hash))['offers']
  end
end
