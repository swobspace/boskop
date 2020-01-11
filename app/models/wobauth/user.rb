require_dependency 'wobauth/concerns/models/user_concerns'
class Wobauth::User < ApplicationRecord
  # dependencies within wobauth models
  include UserConcerns

  # make devise modules configurable: see config/initializers/boskop.rb
  devise *Boskop.devise_modules
end
