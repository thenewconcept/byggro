Rails.application.routes.draw do
  resources :projects
  root "projects#index"

    # SESSIONS & USERS
    get   'signup', to: 'registrations#new'
    post  'signup', to: 'registrations#create'
  
    get    'signin', to: 'sessions#new'
    post   'signin', to: 'sessions#create'
    delete 'signout', to: 'sessions#destroy'
  
    get   'password', to: 'passwords#edit'
    patch 'password', to: 'passwords#update'
  
    get   'password/reset', to: 'passwords_resets#new'
    post  'password/reset', to: 'passwords_resets#create'
  
    get   'password/reset/edit', to: 'passwords_resets#edit'
    patch 'password/reset/edit', to: 'passwords_resets#update'
end
