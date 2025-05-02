require "test_helper"

class Admin::TradersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_traders_index_url
    assert_response :success
  end

  test "should get new" do
    get admin_traders_new_url
    assert_response :success
  end

  test "should get create" do
    get admin_traders_create_url
    assert_response :success
  end
end
