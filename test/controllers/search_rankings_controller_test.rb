require "test_helper"

class SearchRankingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @search_ranking = search_rankings(:one)
  end

  test "should get index" do
    get search_rankings_url
    assert_response :success
  end

  test "should get new" do
    get new_search_ranking_url
    assert_response :success
  end

  test "should create search_ranking" do
    assert_difference("SearchRanking.count") do
      post search_rankings_url, params: { search_ranking: {  } }
    end

    assert_redirected_to search_ranking_url(SearchRanking.last)
  end

  test "should show search_ranking" do
    get search_ranking_url(@search_ranking)
    assert_response :success
  end

  test "should get edit" do
    get edit_search_ranking_url(@search_ranking)
    assert_response :success
  end

  test "should update search_ranking" do
    patch search_ranking_url(@search_ranking), params: { search_ranking: {  } }
    assert_redirected_to search_ranking_url(@search_ranking)
  end

  test "should destroy search_ranking" do
    assert_difference("SearchRanking.count", -1) do
      delete search_ranking_url(@search_ranking)
    end

    assert_redirected_to search_rankings_url
  end
end
