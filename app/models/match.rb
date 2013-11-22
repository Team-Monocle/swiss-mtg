class Match < ActiveRecord::Base
  belongs_to :tournament
  belongs_to :player_1, :class_name => "PlayerTournament"
  belongs_to :player_2, :class_name => "PlayerTournament"

  def self.finished
    self.where("game_1 IS NOT null AND game_1 >= 0")
  end

  def finished?
    self.game_1 && self.game_1 >= 0
  end
end

