json.array!(@groups) do |group|
  json.extract! group, :id, :name, :location, :latitude, :longitude
  json.url group_url(group, format: :json)
end
