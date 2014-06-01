require 'geocoder'
require "rubygems"
require "open-uri"
require "nokogiri"

class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :edit, :update, :destroy]

  # GET /rooms
  # GET /rooms.json
  def index
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

  end
  
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
  		if @entryURL.size == 20
  			break
  		end
  	end
  	@entryURL.each do |url|
  		@room = Room.new
	  	entry = Nokogiri::HTML(open(url))
  		entry.css('#pagecontainer .body .userbody .mapAndAttrs div:nth-child(2)').each do |elem|
  			@room.address = elem.content
  		end
  		
  		entry.css('#pagecontainer .body .userbody .mapAndAttrs .attrgroup span:first-child b:first-child').each do |elem|
  			@room.apt_roomnum = elem.content
  		end
  		
  		entry.css('#pagecontainer .body .userbody .mapAndAttrs .attrgroup span:first-child b:nth-child(2)').each do |elem|
  			@room.apt_bathnum = elem.content
  		end
  		
  		entry.css('#pagecontainer .body .postingtitle').each do |elem|
  			@room.desc = elem.content
  			puts elem.content
  			#rent = /\$(\d+)/.match(elem.content)[1]
            rent = elem.content.scan(/\$(\d+)/)[1]
  			@room.rent = rent.to_f
  		end
  		
  		
  		found = false
  		@rooms.each do |record|
  			if record.address == @room.address
  				found = true
  				break
  			end
  		end
  		if found == false
  			@room.save
  		end
  		
  		#address = entry.css('#pagecontainer .body .userbody .mapAndAttrs .attrgroup ').content
  	end
  end		
  helper_method :pull_data_from_craiglist;
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def room_params
      params.require(:room).permit(:entry_id, :latitude, :longitude, :address, :rent, :util_fee, :apt_roomnum, :apt_bathnum, :apt_gender, :univ_id, :acpt_distance, :desc)
    end
end
