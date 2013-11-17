class Match < ActiveRecord::Base
  belongs_to :tournament
  belongs_to :player_1, :class_name => "PlayerTournament"
  belongs_to :player_2, :class_name => "PlayerTournament"
end

