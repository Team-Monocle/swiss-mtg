class Tournament < ActiveRecord::Base
  has_many :matches
  has_many :player_tournaments
  has_many :players, through: :player_tournaments
  has_many :user_tournaments
  has_many :users, through: :user_tournaments
end
