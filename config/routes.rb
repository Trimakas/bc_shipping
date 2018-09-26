Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'
  post '/', to: 'welcome#index'
  post 'rates', to: 'rate#rates'
  get 'where_to_send_user' => 'welcome#where_to_send_user'
  
  post 'orders_update', to: 'order#receive_order_update'  
  
  get '/auth/:name/callback' => 'omniauth#callback'
  get '/load' => 'omniauth#load'
  get '/uninstall' => 'omniauth#uninstall'
  
  post 'amazon_credentials_check', to: 'amazon_creds#amazon_credentials_check'
  get 'return_amazon_credentials' => 'amazon_creds#return_amazon_credentials' 
  
  get 'return_currency_info' => 'currency#return_currency_info' 
  
  post 'save_shipping_info', to: 'speed#save_shipping_info'
  post 'delete_speed', to: 'speed#delete_speed'
  get 'return_speed_info' => 'speed#return_speed_info'
  get 'number_of_speeds_to_return' => 'speed#number_of_speeds_to_return'  
  
  get 'return_zone_info' => 'zone#return_zone_info'
  post 'receive_zone_info' => 'zone#receive_zone_info'
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
