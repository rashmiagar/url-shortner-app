Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

post '/shorten', to: 'shortened_urls#shorten'
get '/redirect/:id', to: 'shortened_urls#redirect'

end
