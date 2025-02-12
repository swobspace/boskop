Rails.application.routes.draw do
  resources :network_interfaces, except: [:new, :create]
  post "network_interfaces", to: "network_interfaces#index", constraints: lambda {|req| req.format == :json}
  resources :mac_prefixes

  resources :nessus_scans do
    collection do
      post :update_list
    end
    member do
      put :import
    end
  end
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
    resources :network_interfaces, module: :hosts
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
  resources :framework_contracts do
    resources :lines, module: :framework_contracts
  end
  resources :line_states
  resources :access_types
  post "networks", to: "networks#index", constraints: lambda {|req| req.format == :json}
  resources :networks do
    collection do
      get :search
      post :search
      get :search_form
      get :usage_form
      post :usage
    end
  end

  resources :org_units

  resources :addresses

  get "locations/new", to: "locations#new"
  get "locations/:lid", to: "locations#by_lid", constraints: { lid: /[A-Za-z]+/ }
  resources :locations, constraints: { id: /[0-9]+/ }

  resources :merkmale

  resources :merkmalklassen

  root 'locations#index'

  mount Wobauth::Engine, at: '/auth'

  authenticate :user, ->(user) { user.is_admin? } do
    mount GoodJob::Engine => "good_job"
  end

end
