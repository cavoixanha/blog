Rails.application.routes.draw do
  resources :comments
  root 'posts#index'
  resources :posts do
    resources :comments do
      collection do
        get 'new_comment_for_post', as: :new_comment_for_post
      end
    end
    # collection do
    #   get 'new_comment_for_post', as: :new_comment_for_post
    # end
  end
  devise_for :users#, :controllers => { :sessions => "sessions" }
  namespace :api do
    namespace :v1 do
      resources :posts do
        collection do
          get 'search'
        end
      end
      resources :comments
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
