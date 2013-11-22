class Addindexestocolumns < ActiveRecord::Migration
  def change
    add_index :user_tournaments, :user_id
    add_index :user_tournaments, :tournament_id
    add_index :player_tournaments, :player_id
    add_index :player_tournaments, :tournament_id
  end
end
