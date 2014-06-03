class Room < ActiveRecord::Base
	geocoded_by :address
	after_validation :geocode
	def self.search(query)
	  univ = nil
	  if query[0] == ''
	  	return Room
	  end
	  
	  if query[1] == ''
	  	univ_id = 404
	  else
		  univ = University.where("univ_name like ?", "%#{query[1]}%").last
		  univ_id = univ.univ_id rescue univ_id = 404
	  end
	  
	  if query[0] =~ /^\d+$/
	  	return Room.where("acpt_distance < ? and univ_id like ?", "#{query[0]}","%#{univ_id}%")
	  	#return Room.where("acpt_distance < ?", "#{query[0]}")
	  elsif query[0] =~ /^\$\d+$/
	  	money = /^\$(\d+)$/.match(query[0])[1]
	  	return Room.where("rent < ? and univ_id like ?", money, "%#{univ_id}%")
	  else
	  	return Room.where("(address like ? or desc like ?) and univ_id like ?", "%#{query[0]}%", "%#{query[0]}%","%#{univ_id}%")
	  end
	end
	
validates :address, presence: true
validates :rent, presence: true
#validates :util_fee, presence: true
validates :apt_roomnum, presence: true
has_attached_file :image
validates_attachment :image, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }
end

