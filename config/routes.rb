Rails.application.routes.draw do
  resources :software_categories
  resources :software do
    member do
      patch :assign_raw_software
    end
    resources :hosts, only: [:index], module: :software do
      collection do
        post :index, constraints: lambda {|req| req.format == :json}
      end
    end
    resources :software_raw_data, only: [:remove], module: :software do
      member do
        patch :remove
      end
    end
  end
  post "software_raw_data", to: "software_raw_data#index", constraints: lambda {|req| req.format == :json}
  resources :software_raw_data do
    member do
      get :add_software
      patch :remove
    end
    collection do
      get :search
      post :search
      get :search_form
      get :new_import
      post :import
    end
  end
  resources :network_interfaces, except: [:new, :create]
  post "network_interfaces", to: "network_interfaces#index", constraints: lambda {|req| req.format == :json}
  resources :mac_prefixes
  resources :ad_users,  :only => [:index] do
    collection do
      post :index
    end
  end

  resources :responsibilities
  resources :contacts
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

  get "locations/new", to: "locations#new"
  get "locations/:lid", to: "locations#by_lid", constraints: { lid: /[A-Za-z]+/ }
  resources :locations, constraints: { id: /[0-9]+/ }

  resources :merkmale

  resources :merkmalklassen

  root 'locations#index'

  mount Wobauth::Engine, at: '/auth'

end
