json.array!(@rooms) do |room|
  json.extract! room, :id, :entry_id, :latitude, :longitude, :address, :rent, :util_fee, :apt_roomnum, :apt_bathnum, :apt_gender, :univ_id, :acpt_distance, :desc
  json.url room_url(room, format: :json)
end
