class AddSlugsToTournamentsAndUsers < ActiveRecord::Migration
  def change
    add_column :tournaments, :slug, :string
    add_column :users, :slug, :string
  end
end
