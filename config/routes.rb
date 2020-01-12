Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  devise_for :players, skip: :all
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  scope :players, defaults: { format: 'json' } do
    devise_scope :player do
      post   'login'    => 'users/sessions#create'
      delete 'logout'   => 'users/sessions#destroy'
    end

    post ''             => 'players#create'
    get ':id'           => 'players#show'
    put ':id'           => 'players#update_profile'
    post 'follow'       => 'players#follow'
    get ':id/followers' => 'players#followers'
  end
end
