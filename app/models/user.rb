class User < ActiveRecord::Base
  has_many :user_tournaments
  has_many :tournaments, through: :user_tournaments
end
