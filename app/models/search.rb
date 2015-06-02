class Search
  def initialize(params)
    @params = params
  end

  def results
    valid? ? json['offers'] : []
  end

  private

  def valid?
    json['code'] == "OK" and valid_signature?
  end

  def json
    @json ||= JSON.parse(response)
  end

  def response
    @response ||= RestClient.get("http://api.sponsorpay.com/feed/v1/offers.json", params: all_params)
  end

  def valid_signature?
    Digest::SHA1.hexdigest("#{response}#{api_key}") == response.headers[:x_sponsorpay_response_signature]
  end

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
    Digest::SHA1.hexdigest(request_params.sort_by { |key, _| key.to_s }.map { |pair| pair.join("=") }.join("&") + "&#{api_key}")
  end

  def api_key
    Rails.application.secrets.fyber['api_key']
  end
end
