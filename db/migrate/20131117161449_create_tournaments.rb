class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.string :name
      t.integer :number_of_rounds
      t.integer :current_round
      
      t.timestamps
    end
  end
end
