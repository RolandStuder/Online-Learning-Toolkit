App::Application.routes.draw do

  get "user_sessions/new"

  resources :peer_review_feedbacks
  resources :peer_review_solutions
  

  resources :users
  
  get 'login' => 'user_sessions#new', :as => :login
  post 'login' => 'user_sessions#create', :as => :login
  delete 'logout' => 'user_sessions#destroy', :as => :logout
  get 'test' => 'user_sessions#test', :as => :test

  resources :user_sessions
  
  

  resources :peer_review_assignments do
    get 'solution'
    resources :peer_review_solutions
  end

  resources :peer_reviews do
        resources :peer_review_assignments
        resources :peer_review_solutions
        
        member do
          post 'assign'
          get 'assign'
          get 'temp'
          post 'assign_participants'
          get 'start_feedbacks_manually'
          post 'start'
          get 'test'
        end
        
  end
  
  

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.

  match "/peer_review_feedbacks/:id/:action" => "peer_review_feedbacks#:action"
  match ':action' => 'show#:action'
  match '/' => 'show#welcome'
  
  
	
end
