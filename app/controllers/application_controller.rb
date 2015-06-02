class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def offers
    @offers = Search.new(params[:offers]).results
  end
end
