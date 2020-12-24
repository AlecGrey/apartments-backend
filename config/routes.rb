Rails.application.routes.draw do
  # ~~ NEIGHBORHOODS ~~ #
  get '/neighborhoods', to: 'neighborhoods#index'
  get 'neighborhoods/details', to: 'neighborhoods#details'
  # ~~ USER LOGIN/SIGNUP ~~ #
  post '/signup', to: 'users#create'
  post '/login', to: 'users#login'

end
