class PlayerTournament < ActiveRecord::Base
  belongs_to :player
  belongs_to :tournament
  has_many :matches_as_1, foreign_key: "player_1_id",class_name: "Match"
  has_many :matches_as_2, foreign_key: "player_2_id",class_name: "Match"


  def matches
    self.matches_as_1 + self.matches_as_2
  end

  def finished_matches
    self.matches_as_1.finished + self.matches_as_2.finished
  end

  def match_points
    match_wins * 3 + match_draws
  end

  def game_points
    ((game_wins * 3) + game_draws)
  end

  def record
    "#{self.match_wins} - #{self.match_losses} - #{self.match_draws}"
  end

  def game_win_percent
    self.game_points / (games * 3.0)
  end

  def match_win_percent
    self.match_wins / (self.matches_played.size * 1.0)
  end

  def match_wins
    wins = self.matches.select do |m|
      total = 0
      total += 1 if m.game_1 == self.id
      total += 1 if m.game_2 == self.id 
      total += 1 if m.game_3 == self.id
      total = 2 if (total == 1 && m.game_2 == 0 && m.game_3 == nil)
      total == 2
    end
    wins.length
  end

  def match_losses
    losses = self.matches.select do |m|
      total = 0
      total += 1 if (m.game_1 != self.id) && (m.game_1 != nil) && (m.game_1 != 0) 
      total += 1 if (m.game_2 != self.id) && (m.game_2 != nil) && (m.game_2 != 0)
      total += 1 if (m.game_3 != self.id) && (m.game_3 != nil) && (m.game_3 != 0)
      total = 2 if (total == 1 && m.game_2 == 0 && m.game_3 == nil)
      total == 2
    end
    losses.length
  end

  def match_draws
    self.finished_matches.length - match_wins - match_losses
  end

  def games
    total = 0
    self.matches.each do |m|
      total += 1 if m.game_1 != nil
      total += 1 if m.game_2 != nil
      total += 1 if m.game_3 != nil
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
    self.matches.select{|m| m.player_2_id != nil}
  end

  def opponents_game_avg
    played = self.matches_played
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
    points = self.matches_played.collect do |m|
      if m.player_1_id != self.id
        m.player_1.match_win_percent
      else
        m.player_2.match_win_percent
      end
    end
    points.inject{|total, n| total += n } / (self.matches_played.size * 1.0)
  end






end
