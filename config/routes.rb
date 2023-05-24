Rails.application.routes.draw do
  root 'pages#index'

  namespace :api do
    namespace :v1 do
      resources :questions
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end