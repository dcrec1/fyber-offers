class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def offers
    @offers = Offer.all(params[:offers])
  end
end
