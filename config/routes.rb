Rails.application.routes.draw do
  root to: 'application#index'
  get '/offers' => 'application#offers', as: :offers
end
