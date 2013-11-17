class UserTournament < ActiveRecord::Base
  belongs_to :users
  belongs_to :tournaments
end
