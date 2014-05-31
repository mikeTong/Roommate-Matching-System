require 'test_helper'

class RoomsControllerTest < ActionController::TestCase
  setup do
    @room = rooms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rooms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create room" do
    assert_difference('Room.count') do
      post :create, room: { acpt_distance: @room.acpt_distance, address: @room.address, apt_bathnum: @room.apt_bathnum, apt_gender: @room.apt_gender, apt_roomnum: @room.apt_roomnum, desc: @room.desc, entry_id: @room.entry_id, latitude: @room.latitude, longitude: @room.longitude, rent: @room.rent, univ_id: @room.univ_id, util_fee: @room.util_fee }
    end

    assert_redirected_to room_path(assigns(:room))
  end

  test "should show room" do
    get :show, id: @room
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @room
    assert_response :success
  end

  test "should update room" do
    patch :update, id: @room, room: { acpt_distance: @room.acpt_distance, address: @room.address, apt_bathnum: @room.apt_bathnum, apt_gender: @room.apt_gender, apt_roomnum: @room.apt_roomnum, desc: @room.desc, entry_id: @room.entry_id, latitude: @room.latitude, longitude: @room.longitude, rent: @room.rent, univ_id: @room.univ_id, util_fee: @room.util_fee }
    assert_redirected_to room_path(assigns(:room))
  end

  test "should destroy room" do
    assert_difference('Room.count', -1) do
      delete :destroy, id: @room
    end

    assert_redirected_to rooms_path
  end
end
