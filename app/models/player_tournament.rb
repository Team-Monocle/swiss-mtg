class PlayerTournament < ActiveRecord::Base
  belongs_to :players
  belongs_to :tournaments
  has_many :matches
end
