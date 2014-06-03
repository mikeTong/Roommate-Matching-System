class Room < ActiveRecord::Base
	geocoded_by :address
	after_validation :geocode
	def self.search(query)
	  if query =~ /^\d+$/
	  	return Room.where("acpt_distance < ? ", "#{query}")
	  elsif query =~ /^\$\d+$/
	  	money = /^\$(\d+)$/.match(query)[1]
	  	return Room.where("rent < ? ", money)
	  else
	  	return Room.where("address like ? or desc like ?", "%#{query}%", "%#{query}%")
	  end
	end

validates :address, presence: true
validates :rent, presence: true
#validates :util_fee, presence: true
validates :apt_roomnum, presence: true
has_attached_file :image
validates_attachment :image, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }
end

