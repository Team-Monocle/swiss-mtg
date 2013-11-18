class Tournament < ActiveRecord::Base
  has_many :matches
  has_many :player_tournaments
  has_many :players, through: :player_tournaments
  has_many :user_tournaments
  has_many :users, through: :user_tournaments


  def generate
    assess_rounds #this shouldn't be called every time -manley
    self.current_round ||= 0
    self.current_round += 1
    round_matches
    self.save
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

  def round_matches
    player_list = self.player_tournaments.to_a.shuffle 
    player_list ||= self.order_players
    while player_list.size > 0
      if player_list.size == 1
        player_list[0].had_bye = true
      end
      self.matches.create(:player_1 => player_list.shift, :player_2 => player_list.shift, :round => self.current_round)
    end
  end

  def order_players
    self.player_tournaments.sort_by{|p| -p.match_points }
  end




end