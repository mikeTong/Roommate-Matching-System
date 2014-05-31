class Room < ActiveRecord::Base
	geocoded_by :address
	after_validation :geocode
	def self.search(query)
	  Room.where("address like ?", "%#{query}%")
	end
end
