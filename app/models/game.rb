class Game < ActiveRecord::Base
    has_many :joins
    has_many :users, through: :joins
    has_many :tasks
    has_many :hosts
end
