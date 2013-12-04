class PlayerTournament < ActiveRecord::Base
  belongs_to :player
  belongs_to :tournament
  has_many :matches_as_1, foreign_key: "player_1_id",class_name: "Match"
  has_many :matches_as_2, foreign_key: "player_2_id",class_name: "Match"

  has_many :finished_matches_as_1, foreign_key: "player_1_id",class_name: "Match", :conditions => ['game_1 IS NOT null AND game_1 >= 0']
  has_many :finished_matches_as_2, foreign_key: "player_2_id",class_name: "Match", :conditions => ['game_1 IS NOT null AND game_1 >= 0']


  def matches
    self.matches_as_1 + self.matches_as_2
  end

  def finished_matches
    self.finished_matches_as_1 + self.finished_matches_as_2
  end

  def match_points
    points = (match_wins * 3) + match_draws
    had_bye ? points + 3 : points
  end

  def game_points
    ((game_wins * 3) + game_draws) 
  end

  def record
    "#{self.match_wins} - #{self.match_losses} - #{self.match_draws}"
  end

  def game_win_percent
    return 0 if self.matches_played.size == 0
    self.game_points / (games * 3.0)
  end

  def match_win_percent
    return 0 if self.matches_played.size == 0
    wins = (self.had_bye && self.tournament.finished) ? match_wins - 1 : match_wins
    percent = (wins * 3 + self.match_draws) / (self.matches_played.size * 3.0)
    percent > 0.33 ? percent : 0.3333
  end

  def match_wins
    wins = self.matches_played.select do |m|
      total = 0
      total += 1 if m.game_1 == self.id
      total += 1 if m.game_2 == self.id 
      total += 1 if m.game_3 == self.id
      total = 2 if (total == 1 && (m.game_2 <= 0 || m.game_2 == nil) && (m.game_3 == nil || m.game_3 < 0))
      total == 2
    end
    wins.length
  end

  def match_losses
    losses = self.matches_played.select do |m|
      total = 0
      total += 1 if m.game_1 && (m.game_1 != self.id) && (m.game_1 > 0)
      total += 1 if m.game_2 && (m.game_2 != self.id) && (m.game_2 > 0)
      total += 1 if m.game_3 && (m.game_3 != self.id) && (m.game_3 > 0)
      total = 2 if (total == 1 && (m.game_2 <= 0 || m.game_2 == nil) && (m.game_3 == nil || m.game_3 < 0))
      total == 2
    end
    losses.length
  end

  def match_draws
    self.matches_played.size - match_wins - match_losses
  end

  def games
    total = 0
    self.matches.each do |m|
      total += 1 if m.game_1 && m.game_1 >= 0 
      total += 1 if m.game_2 && m.game_2 >= 0 
      total += 1 if m.game_3 && m.game_3 >= 0 
    end
    total
  end

  def game_wins
    wins = 0
    self.matches.each do |m|
      wins += 1 if m.game_1 == self.id
      wins += 1 if m.game_2 == self.id
      wins += 1 if m.game_3 == self.id
    end
    wins
  end

  def game_draws
    draws = 0
    self.matches.each do |m|
      draws += 1 if m.game_1 == 0
      draws += 1 if m.game_2 == 0
      draws += 1 if m.game_3 == 0
    end
    draws

  end

  def matches_played
    self.finished_matches.select{|m| m.player_2_id && m.player_2_id >= 0 }
  end

  def opponents_game_avg
    played = self.matches_played
    return 0 if played.size == 0
    points = played.collect do |m|
      if m.player_1_id != self.id
        m.player_1.game_win_percent
      else
        m.player_2.game_win_percent
      end
    end

    points.inject{|total, n| total += n } / (played.size * 1.0)

  end

  def opponents_match_avg
    played = self.matches_played
    return 0 if played.size == 0
    points = played.collect do |m|
      if m.player_1_id != self.id
        m.player_1.match_win_percent
      else
        m.player_2.match_win_percent
      end
    end
    points.inject{|total, n| total += n } / (played.size * 1.0)
  end






end
