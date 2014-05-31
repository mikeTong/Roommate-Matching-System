class Room < ActiveRecord::Base
	geocoded_by :address
	after_validation :geocode
	def self.search(query)
	  Room.where("address like ?", "%#{query}%")
	end

validates :address, presence: true
validates :rent, presence: true
validates :util_fee, presence: true
validates :apt_roomnum, presence: true


end

