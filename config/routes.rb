Rails.application.routes.draw do
  root 'classrooms#index'	
  resources :students
  resources :classrooms
  post 'students/create', :as => 'create_student' 
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
