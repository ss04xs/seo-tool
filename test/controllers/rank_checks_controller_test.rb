require "test_helper"

class RankChecksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @rank_check = rank_checks(:one)
  end

  test "should get index" do
    get rank_checks_url
    assert_response :success
  end

  test "should get new" do
    get new_rank_check_url
    assert_response :success
  end

  test "should create rank_check" do
    assert_difference("RankCheck.count") do
      post rank_checks_url, params: { rank_check: { get_date: @rank_check.get_date, gsp_rank: @rank_check.gsp_rank, keyword: @rank_check.keyword, site_id_id: @rank_check.site_id_id, url: @rank_check.url, zone_type: @rank_check.zone_type } }
    end

    assert_redirected_to rank_check_url(RankCheck.last)
  end

  test "should show rank_check" do
    get rank_check_url(@rank_check)
    assert_response :success
  end

  test "should get edit" do
    get edit_rank_check_url(@rank_check)
    assert_response :success
  end

  test "should update rank_check" do
    patch rank_check_url(@rank_check), params: { rank_check: { get_date: @rank_check.get_date, gsp_rank: @rank_check.gsp_rank, keyword: @rank_check.keyword, site_id_id: @rank_check.site_id_id, url: @rank_check.url, zone_type: @rank_check.zone_type } }
    assert_redirected_to rank_check_url(@rank_check)
  end

  test "should destroy rank_check" do
    assert_difference("RankCheck.count", -1) do
      delete rank_check_url(@rank_check)
    end

    assert_redirected_to rank_checks_url
  end
end
