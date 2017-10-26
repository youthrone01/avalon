class User < ActiveRecord::Base
  has_secure_password
  has_many :joins
  has_many :games, through: :joins
end
