Rails.application.routes.draw do
  # ~~ NEIGHBORHOODS ~~ #
  get '/neighborhoods', to: 'neighborhoods#index'
  get 'neighborhoods/details', to: 'neighborhoods#details'
  # ~~ USER LOGIN/SIGNUP ~~ #
  post '/signup', to: 'users#create'
  get '/login', to: 'users#login'

end
