class CreatePlayerTournaments < ActiveRecord::Migration
  def change
    create_table :player_tournaments do |t|
      t.integer :player_id
      t.integer :tournament_id
      t.boolean :had_bye
      t.timestamps
    end
  end
end
