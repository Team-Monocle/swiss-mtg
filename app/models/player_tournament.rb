class PlayerTournament < ActiveRecord::Base
  belongs_to :player
  belongs_to :tournament
  has_many :matches


  def record
    "#{self.wins} - #{self.losses} - #{self.draws}"
  end

  def wins
    # self.matches
  end

  def losses

  end

  def draws

  end
end
