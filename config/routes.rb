Rails.application.routes.draw do
  resources :pages

  get :harvest, to: 'harvest#index'

  resources :clients
  resources :users do
    resources :employees
  end

  resources :expenses
  resources :projects do
    resources :reports
    resources :notes
    resources :payments
    resources :expenses
    resources :checklists do
      resources :todos
    end
  end

  resources :salaries, only: :index
  resources :reports
  resources :fees

  root "projects#index"

  # SESSIONS & USERS
  get   'signup', to: 'registrations#new'
  post  'signup', to: 'registrations#create'
  
  get    'signin', to: 'sessions#new'
  post   'signin', to: 'sessions#create'
  delete 'signout', to: 'sessions#destroy'
  post   'switch', to: 'sessions#switch'
  
  get   'password', to: 'passwords#edit'
  patch 'password', to: 'passwords#update'
  
  get   'password/reset', to: 'passwords_resets#new'
  post  'password/reset', to: 'passwords_resets#create'
  
  get   'password/reset/edit', to: 'passwords_resets#edit'
  patch 'password/reset/edit', to: 'passwords_resets#update'
end
