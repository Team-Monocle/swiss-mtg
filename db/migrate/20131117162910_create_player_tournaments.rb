class CreatePlayerTournaments < ActiveRecord::Migration
  def change
    create_table :player_tournaments do |t|
      t.integer :player_id
      t.integer :tournament_id
      t.integer :bye_round
      t.timestamps
    end
  end
end
