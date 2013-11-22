class CreateUserTournaments < ActiveRecord::Migration
  def change
    create_table :user_tournaments do |t|
      t.integer :user_id, index: true
      t.integer :tournament_id, index: true
  

      t.timestamps
    end
  end
end
