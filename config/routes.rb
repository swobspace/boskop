Rails.application.routes.draw do
  resources :nessus_scans
  post "vulnerabilities", to: "vulnerabilities#index", constraints: lambda {|req| req.format == :json}
  resources :vulnerabilities do
    collection do
      get :search
      post :search
      get :search_form
      get :new_import
      post :import
    end
  end
  resources :vulnerability_details
  resources :operating_system_mappings
  resources :operating_systems
  resources :host_categories
  post "hosts", to: "hosts#index", constraints: lambda {|req| req.format == :json}
  post "hosts/:host_id/vulnerabilities", to: "hosts/vulnerabilities#index",
        constraints: lambda {|req| req.format == :json}
  resources :hosts do
    resources :vulnerabilities, only: [:index], module: :hosts
    collection do
      get :eol_summary
      get :vuln_risk_matrix
      get :search
      post :search
      get :search_form
      get :new_import
      post :import
    end
  end
  resources :lines do
    collection do
      get :search
      post :search, action: :index
    end
  end
  resources :framework_contracts
  resources :line_states
  resources :access_types
  resources :networks do
    collection do
      get :search
      post :search, action: :index
      get :usage_form
      post :usage
    end
  end

  resources :org_units

  resources :addresses

  resources :locations

  resources :merkmale

  resources :merkmalklassen

  root 'locations#index'

  mount Wobauth::Engine, at: '/auth'

end
