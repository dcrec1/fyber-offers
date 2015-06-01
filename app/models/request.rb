class Request
  def initialize(params)
    @params = params
  end

  def valid?
    Digest::SHA1.hexdigest("#{response}#{api_key}") == response.headers[:x_sponsorpay_response_signature]
  end

  def response
    @response ||= RestClient.get("http://api.sponsorpay.com/feed/v1/offers.json", params: all_params)
  end

  private

  def all_params
    request_params.merge hashkey: hashkey
  end

  def request_params
    @request_params ||= secret_params.merge(@params).merge(mock_params).merge timestamp: Time.now.to_i
  end

  def secret_params
    Rails.application.secrets.fyber.slice('appid', 'ip', 'device_id', 'idfa')
  end

  def mock_params
    { apple_idfa_tracking_enabled: false, os_version: '6.0', offer_types: 112, locale: 'de' }
  end

  def hashkey
    Digest::SHA1.hexdigest(request_params.to_a.sort { |a, b| a[0].to_s <=> b[0].to_s }.map { |pair| "#{pair[0]}=#{pair[1]}" }.join("&") + "&#{api_key}")
  end

  def api_key
    Rails.application.secrets.fyber['api_key']
  end
end

