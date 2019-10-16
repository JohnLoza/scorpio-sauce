Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root controller: 'application', action: 'home'

  namespace :admin do

  end

  namespace :api do
    post 'log_in', controller: 'sessions', action: 'create'
    resources :users
  end

  match '*path', via: :all, to: 'application#render_404'
end
