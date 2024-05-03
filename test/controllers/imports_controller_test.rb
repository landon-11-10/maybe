require "test_helper"

class ImportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in @user = users(:family_admin)
    @import = imports(:basic_checking_account_import)
  end

  test "should get index" do
    get imports_url
    assert_response :success
  end

  test "should get new" do
    get new_import_url
    assert_response :success
  end

  test "should create import" do
    assert_difference("Import.count") do
      post imports_url, params: { import: { account_id: @import.account_id, column_mappings: @import.column_mappings } }
    end
  end

  test "should get edit" do
    get edit_import_url(@import)
    assert_response :success
  end

  test "should destroy import" do
    assert_difference("Import.count", -1) do
      delete import_url(@import)
    end

    assert_redirected_to imports_url
  end
end
