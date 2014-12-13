class Wobauth::User < ActiveRecord::Base
  # dependencies within wobauth models
  include Wobauth::Concerns::Models::User

  # make devise modules configurable: see config/initializers/boskop.rb
  devise *Boskop.devise_modules
end
