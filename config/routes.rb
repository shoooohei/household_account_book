Rails.application.routes.draw do

  get 'settings/index'

  get 'settings/show'

  resources :sessions, only: [:new, :create, :destroy]

  resources :users do
    resources :settings, only: [:index] do
      get :change_allow_share_mine, on: :collection
    end
  end
  resources :partners, only:[:new, :create, :destroy]

  resources :expenses do
    collection do
      get :both
      post :confirm
    end
  end

  resources :notifications, only: [:index, :create, :destroy]

  get 'category_expenses/:category_id/:cnum', to: 'expenses#each_category', as: :each_category_expense

  get 'shift_months/past/:id', to: 'shift_months#past', as: :past_expense
  get 'shift_months/future/:id', to: 'shift_months#future', as: :future_expense

  resources :repeat_expenses do
    collection do
      get :both
      post :confirm
    end
  end

  resources :categories do
    collection do
      get :common
    end
  end
  resources :badgets
  resources :pays
  resources :wants do
    get :change_bought_button, on: :member
  end

  # get 'bought_buttons/bought/:id', to: 'bought_buttons#bought', as: :bought
  # get 'bought_buttons/want/:id', to: 'bought_buttons#want', as: :back_to_want

  root to: "expenses#both"
end
