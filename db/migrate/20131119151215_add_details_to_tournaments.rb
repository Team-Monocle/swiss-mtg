class AddDetailsToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :format, :string
    add_column :tournaments, :location, :string
    add_column :tournaments, :date, :date
    add_column :tournaments, :details, :text
  end
end
