class PlayerTournament < ActiveRecord::Base
  belongs_to :player
  belongs_to :tournament
  has_many :matches
end
