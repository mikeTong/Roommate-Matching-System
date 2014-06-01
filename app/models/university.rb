class University < ActiveRecord::Base
validates :univ_addr, presence: true
validates :univ_id, presence: true
end
