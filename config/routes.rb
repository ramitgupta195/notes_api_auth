Rails.application.routes.draw do
  devise_for :users,
    path: "",
    path_names: {
      sign_in: "login",
      sign_out: "logout",
      registration: "signup"
    },
    controllers: {
      sessions: "users/sessions",
      registrations: "users/registrations"
    }

  resources :notes
  namespace :admin do
    resources :users, only: [ :index, :update, :destroy ]
  end

  namespace :users do
    resource :profile, only: [ :show, :update ]
  end
  namespace :admin do
    resources :activity_logs, only: [ :index ]
  end
end
