# -*- encoding : utf-8 -*-
Evbdup::Application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'home#index'
  root :to => 'home#index'

  # captcha_route
  # 验证码
  mount RuCaptcha::Engine => "/rucaptcha"

  get 'errors' => 'errors#index'
  get 'main' => 'kobe/main#index'
  get 'not_found' => "home#not_found", as: :not_found
  # 前台显示
  get "search", :to => 'home#search', :as => "search"
  get 'channel/(:combo)' => "home#channel", :as => :channel
  get 'details/(:pid)' => "home#details", as: :details
  get 'hesay' => "home#hesay", as: :hesay

  get 'sign_in', :to => 'users#sign_in'
  get 'sign_up', :to => 'users#sign_up'

  # 后台
  get 'products/(:ca_id)' => "kobe/products#index", as: :products
  get 'new/(:ca_id)' => "kobe/products#new", as: :new

  resources :uploads, :only => [:index, :create, :destroy]

  resources :users, :except => :show  do
    collection do
      get :sign_out, :forgot_password
      post :login, :create_user_dep, :valid_dep_name, :valid_user_login, :valid_captcha, :valid_user
    end
  end

  resources :sessions, :only => [:new, :create, :destroy]

# 后台begin
namespace :kobe do
  resources :shared, :only => :index do
    collection do
      post :item_ztree_json, :get_ztree_title, :ztree_json, :audit_next_user, :ajax_submit, :ajax_remove, :category_ztree_json, :province_area_ztree_json, :department_ztree_json, :get_budgets_json, :user_ztree_json, :save_budget, :item_dep_json, :get_yw_type_json
      get :get_item_category, :get_budget_form
    end
  end

  resources :departments do
    collection do
      get :search, :list
      post :move, :valid_dep_name, :search_bank
    end
    member do
      get :ztree, :add_user, :freeze, :upload, :delete, :recover, :show_bank, :audit
      post :update_add_user, :update_freeze, :update_upload, :commit, :update_recover, :edit_bank, :update_bank, :update_audit
    end
  end
  resources :users do
    member do
      get :reset_password, :freeze, :recover, :only_show_info, :only_show_logs, :invoice_info
      post :update_reset_password, :update_freeze, :update_recover, :update_invoice_info, :simulate_login
    end
  end
  resources :categories do
    collection do
      get :ztree
      post :move, :valid_name
    end
    member do
      get :freeze, :delete, :recover
      post :update_freeze, :update_recover
    end
  end

  resources :tongji, only: :index do
     collection do
       get :item_dep_sales, :invoice_info, :order_details, :export
       post :get_table_name_json
     end
  end

   resources :products do
      member do
        get :freeze, :delete, :recover
        post :update_freeze, :update_recover
      end
    end
  end
# 后台end

resources :kobe, :only => :index do
  collection do
    get :search, :obj_class_json
  end
end

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
