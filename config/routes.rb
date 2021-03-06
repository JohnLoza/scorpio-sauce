Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root controller: 'sessions', action: 'new'
  get 'cities', controller: 'static_pages'
  get 'states', controller: 'static_pages'

  resources :sessions, only: [:new, :create, :destroy]

  namespace :admin do
    get '/', controller: 'home', action: 'index', as: :home

    resources :users do
      post 'restore', on: :member
    end

    resources :products do
      post 'restore', on: :member
    end

    resources :warehouses do
      post 'restore', on: :member
    end

    resources :clients, only: [:index, :show]

    resources :stocks, only: :index do
      get 'transactions', on: :collection
      get 'print_qr', on: :member
      get 'batch_search', on: :collection
    end

    resources :warehouse_shipments, except: [:edit, :update] do
      post 'process_shipment', on: :member
      post 'report', on: :member
      post 'process_report', on: :member
    end

    resources :supply_orders, except: [:edit, :update] do
      post 'supply', on: :member
    end

    resources :tickets, only: [:index, :show] do
      put 'save_invoice_folio', on: :member
    end

    resources :bank_accounts
  end

  namespace :api do
    post 'sessions', controller: 'sessions', action: 'create'
    resources :clients, except: [:new, :edit] do
      get 'locations', on: :collection
    end

    resources :tickets, except: [:new, :edit]
    resources :products, only: [:index, :show]
    resources :route_stocks, only: :show
    resources :bank_accounts, only: :index
  end

  match '*path', via: :all, to: 'application#render_404'
end
