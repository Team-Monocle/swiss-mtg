class Tournament < ActiveRecord::Base
  has_many :matches
  has_many :player_tournaments
  has_many :players, through: :player_tournaments
  has_many :user_tournaments
  has_many :users, through: :user_tournaments


  def start_tournament
    assess_rounds
    initial_matches
  end

  def assess_rounds
    number_of_players = self.players.all.size

    case number_of_players
      when 0..8
        #Throw Error
      when 8
        self.number_of_rounds = 3
      when 9...17
        self.number_of_rounds = 4
      when 17...33
        self.number_of_rounds = 5
      when 33...65
        self.number_of_rounds = 6
      when 65...129
        self.number_of_rounds = 7
      when 129...227
        self.number_of_rounds = 8
      when 227...410
        self.number_of_rounds = 9
      else 
        self.number_of_rounds = 10
    end
    number_of_rounds
  end

  def initial_matches
    players_shuffled = self.player_tournaments.to_a.shuffle
    while players_shuffled.size > 0
      if players_shuffled.size == 1
        players_shuffled.pop.had_bye = true
      end
      self.matches.create(:player_1 => players_shuffled.pop, :player_2 => players_shuffled.pop, :round => 1)
    end
  end






end