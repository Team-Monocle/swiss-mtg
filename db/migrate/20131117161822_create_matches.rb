class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.references :tournament, index: true
      t.integer :player_1_id, index: true
      t.integer :player_2_id, index: true
      t.integer :round, index: true
      t.integer :game_1  
      t.integer :game_2
      t.integer :game_3

      t.timestamps
    end
  end
end
