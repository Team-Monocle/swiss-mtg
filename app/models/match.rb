class Match < ActiveRecord::Base
  belongs_to :tournament
  belongs_to :player_1, class_name :player_tournament
  belongs_to :player_2, class_name :player_tournament
end

