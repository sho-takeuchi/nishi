Rails.application.routes.draw do
  root "top#index"
  devise_for :users

  get  "recruitments/index"  => "recruitments#index"
  get 'recruitments/show/:id' => 'recruitments#show',as:'recruitments_show'

  resources :cards, only:[:index, :new, :create,:destroy,:show] do
  end
end
