require 'test_helper'

class PurchasesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get purchases_index_url
    assert_response :success
  end

  test "should get pay" do
    get purchases_pay_url
    assert_response :success
  end

end
