json.array!(@universities) do |university|
  json.extract! university, :id, :univ_name, :univ_id, :univ_addr
  json.url university_url(university, format: :json)
end
