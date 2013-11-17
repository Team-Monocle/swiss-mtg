json.array!(@tournaments) do |tournament|
  json.extract! tournament, :name, :matches_id
  json.url tournament_url(tournament, format: :json)
end
