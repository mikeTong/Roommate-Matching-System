require 'geocoder'
require "rubygems"
require "nokogiri"
require "open-uri"

class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :edit, :update, :destroy]

  # GET /rooms
  # GET /rooms.json
  def index
	# import the @universities entries
	#@universities = University.all
	#set the search functionality
	
	if params[:search]
		@rooms = Room.search(params[:search]).order("rent")
	else
		@rooms = Room.all
	end
	
    @hash = Gmaps4rails.build_markers(@room) do |room, marker|
  		marker.lat room.latitude
  		marker.lng room.longitude
	end
	
	#No need to call this function again. Used for deleting waste entries
	#delete_waste_entries
	
	#Using for pull info from Craigslist.org, Craigslist.org all rights reserved
	#pull_data_from_craiglist
	
	#controller should change the instance variable 
	#@rooms = Room.all	 #done in calculate_distance
	#If using this, "can't modify frozen Hash" may happen
	#calculate_distance
  end
  
  def refresh_the_home
  	delete_waste_entries
  	pull_data_from_craiglist
  	calculate_distance
  	@room = Room.all
  end
  helper_method :refresh_the_home;
  
  # GET /rooms/1
  # GET /rooms/1.json
  def show
      @hash = Gmaps4rails.build_markers(@room) do |room, marker|
          marker.lat room.latitude
          marker.lng room.longitude
      end

  end

  # GET /rooms/new
  def new
    @room = Room.new
  end

  # GET /rooms/1/edit
  def edit
  end

  # POST /rooms
  # POST /rooms.json
  def create
    @room = Room.new(room_params)
	
    respond_to do |format|
      if @room.save
	  	@universities = University.all
		@universities.each do |university|
			if university.univ_id == @room.univ_id
				puts @room.distance_to(university.univ_addr)
				@room.update_attribute :acpt_distance, @room.distance_to(university.univ_addr)
				break
			end
		end
        format.html { redirect_to @room, notice: 'Room was successfully created.' }
        format.json { render :show, status: :created, location: @room }
      else
        format.html { render :new }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rooms/1
  # PATCH/PUT /rooms/1.json
  def update
    respond_to do |format|
      if @room.update(room_params)
        @universities = University.all
		@universities.each do |university|
			if university.univ_id == @room.univ_id
				puts @room.distance_to(university.univ_addr)
				@room.update_attribute :acpt_distance, @room.distance_to(university.univ_addr)
				break
			end
		end
        format.html { redirect_to @room, notice: 'Room was successfully updated.' }
        format.json { render :show, status: :ok, location: @room }
      else
        format.html { render :edit }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rooms/1
  # DELETE /rooms/1.json
  def destroy
    @room.destroy
    respond_to do |format|
      format.html { redirect_to rooms_url, notice: 'Room was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  def pull_data_from_craiglist
  	@entryURL = []
  	home_url = "http://sfbay.craigslist.org/apa/"
  	list = Nokogiri::HTML(open(home_url))
  	list.css('#pagecontainer #toc_rows .content .row .i').each do |row|
  		second_half_url = row['href']
  		entry_url = 'http://sfbay.craigslist.org' + second_half_url
  		@entryURL.push(entry_url)
  		if @entryURL.size == 30
  			break
  		end
  	end
  	@entryURL.each do |url|
  		@room = Room.new
	  	entry = Nokogiri::HTML(open(url))
  		entry.css('#pagecontainer .body .userbody .mapAndAttrs div:nth-child(2)').each do |elem|
  			puts "this is elem.content " + elem.content
  			@room.address = elem.content 
  			if @room.address == "" || @room.address =~ /^\s+$/
  				@room.address = "N/A"
  			end
  		end
  		
  		entry.css('#pagecontainer .body .userbody .mapAndAttrs .attrgroup span:first-child b:first-child').each do |elem|
  			@room.apt_roomnum = elem.content
  		end
  		
  		entry.css('#pagecontainer .body .userbody .mapAndAttrs .attrgroup span:first-child b:nth-child(2)').each do |elem|
  			@room.apt_bathnum = elem.content
  		end
  		
  		entry.css('#pagecontainer .body .userbody .iw #ci #iwi').each do |elem|
  				@room.image_url = elem['src'] if String(elem['src']) rescue break
  		end
  		
  		entry.css('#pagecontainer .body .postingtitle').each do |elem|
  			@room.desc = elem.content
  			#rent = elem.content.scan(/\$(\d+)/)[1]
  			if /\$(\d+)/.match(elem.content)
  				rent = /\$(\d+)/.match(elem.content)[1]
  			else rent = "not matched"
  			end
  			
			if is_number(rent)
  				@room.rent = rent.to_f
  			else
  				@room.rent = -1.0
  			end
  		end
  		
  		#calculate distance for this address
  		@room.univ_id = 1
=begin
  		@universities = University.all
  		@universities.each do |university|
  			if university.univ_id == @room.univ_id
  				@room.acpt_distance = @room.distance_to(university.univ_addr)
  				puts @room.acpt_distance
  				break
  			end
  		end
=end  		
  		#check whether this room was already listed
  		found = false
  		@rooms.each do |record|
  			if record.address == @room.address
  				found = true
  				#if @room.update(room_params)
  				#else
  				#	puts @room.errors.full_messages
  				#end
  				break
  			end
  		end
  		if found == false
  			puts @room.address
  			if @room.save
  			else
        		puts @room.errors.full_messages
  			end
  		end
  		
  		#address = entry.css('#pagecontainer .body .userbody .mapAndAttrs .attrgroup ').content
  	end
  end		
  helper_method :pull_data_from_craiglist;
  
  def is_number(rent)
    true if Float(rent) rescue false
  end
  
  def calculate_distance
  	@universities = University.all
  	@rooms = Room.all
  	@rooms.each do |room|
  		counted = false
  		if room.address == "N/A"
  			room.update_attribute :acpt_distance, -1.0
  			break
  		end
    	@universities.each do |university|
    		if university.univ_id == room.univ_id
				room.update_attribute :acpt_distance, room.distance_to(university.univ_addr)
				counted = true
			end
		end
		if counted
			puts "distance calculated successfully"
		else room.update_attribute :acpt_distance, -1.0
		end
	end
  end 
  helper_method :calculate_distance;
  
  def delete_waste_entries
  	@rooms = Room.all
  	@rooms.each do |room|
  		# this is indicator of waste room entry. developer can change it
  		if room.entry_id != 1 || room.entry_id != 2
  			room.delete
  		end 
=begin
  		if room.acpt_distance.to_s =='' || room.acpt_distance == -1.0
  			room.delete
  		end
		"do nothing" if Float(room.acpt_distance)  rescue room.delete 
=end
  	end
  end
  helper_method :delete_waste_entries;
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def room_params

      params.require(:room).permit(:entry_id, :latitude, :longitude, :address, :rent, 
      :util_fee, :apt_roomnum, :apt_bathnum, 
      :apt_gender, :univ_id, :acpt_distance, 
      :desc, :usr_name, :landlord, :image_url, :email, :tel, :image)
    end
end
