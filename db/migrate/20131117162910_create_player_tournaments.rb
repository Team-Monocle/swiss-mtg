class CreatePlayerTournaments < ActiveRecord::Migration
  def change
    create_table :player_tournaments do |t|
      t.integer :player_id, index: true
      t.integer :tournament_id, index: true
      t.boolean :had_bye
      t.timestamps
    end
  end
end
