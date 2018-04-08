Rails.application.routes.draw do
  resources :locations
  resources :instructors
  resources :curriculums
  resources :camp_instructors
  resources :camps
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
