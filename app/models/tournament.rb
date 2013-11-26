class Tournament < ActiveRecord::Base
  has_many :matches
  has_many :player_tournaments
  has_many :players, through: :player_tournaments
  has_many :user_tournaments
  has_many :users, through: :user_tournaments

  def generate
    self.current_round ||= 0
    self.current_round += 1
    self.save
    assess_rounds if current_round == 1
    create_matches
    self.save
  end

  def re_generate
    self.matches.sort_by{|m| m.id }.last.player_1.update(had_bye: false) 
    self.matches.where(round: self.current_round).destroy_all
    create_matches
  end

  def end_tournament
    self.finished = true
    self.save
  end

  def round_started
    self.matches.where(round: current_round).where("game_1 IS NOT null").length > 0 
  end

  def assess_rounds
    number_of_players = self.players.all.size
    case number_of_players
      when 0...8
        #Throw Error; Is this deprecated due to dependencies to start tournament?
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

  def create_matches
    if current_round == 1
      player_list = self.player_tournaments.to_a.shuffle
    else
      player_list = already_bye?
    end

    if player_list.size.odd? 
      bye_player = player_list.pop
    end

    player_list = validate_players(player_list)

    while player_list.size > 0
      self.matches.create(:player_1 => player_list.shift, :player_2 => player_list.shift, :round => self.current_round)
    end
    self.matches.create(player_1_id: bye_player.id, round: self.current_round)
    bye_player.update(had_bye: true)
  end

  def validate_players(player_list)
    valid_list = false
    reversed = true
    rep = []
    while !valid_list
      matched = []
      valid_list = true
      reversed = !reversed
      while player_list.size > 0
        if !already_played?(player_list[0], player_list[1])
          valid_list = false if player_list[1] == nil
          matched = matched + player_list.slice!(0, 2)
          player_list = rep + player_list
          rep = []
        else
          rep << player_list.slice!(1)
        end
        matched.compact!
      end
      !valid_list ? player_list = matched.reverse! : player_list = matched
    end
    reversed ? player_list.reverse : player_list
  end

  def already_played?(player_tournament_1, player_tournament_2)
    self.matches.each do |match|
      x = 0
      x += 1 if match.player_1_id == player_tournament_1.id
      x += 1 if match.player_2_id == player_tournament_1.id
      x += 1 if player_tournament_2 && (match.player_1_id == player_tournament_2.id)
      x += 1 if player_tournament_2 && (match.player_2_id == player_tournament_2.id)
      return true if (x == 2)
    end
    false
  end


  def already_bye?
    players = self.order_players.to_a
    if players[-1].had_bye
      next_bye = players.reverse[0..-2].detect { |player| !player.had_bye }
      players.delete(next_bye)
      players << next_bye
    else
      players
    end
  end

  def order_players
    # binding.pry
    self.player_tournaments.includes(:finished_matches_as_1, :finished_matches_as_2).sort_by{|p| [-p.match_points, -p.opponents_match_avg, -p.game_win_percent, -p.opponents_game_avg, p.id] }
  end

  def find_or_create_player(name)
    player = Player.find_or_create_by(:name => name.downcase.titleize)
    self.player_tournaments.find_or_create_by(player_id: player.id)
  end

  def end_message
    #self.format == "Swiss Pairings, Without Finals" ? "End Tournament" : "Generate Finals"
    "End Tournament"
  end

  def round_complete
    completed = self.matches.select {|m| m.game_1 && m.game_1 >= 0 }
    completed.size == self.matches.size
  end

  def finals?
    current_round > number_of_rounds
  end

  def generate_finals
    # if number == 4
    #   pair player one with player four
    #   pair player two with player three
    # elsif number == 8 
  end

end