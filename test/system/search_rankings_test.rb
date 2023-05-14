require "application_system_test_case"

class SearchRankingsTest < ApplicationSystemTestCase
  setup do
    @search_ranking = search_rankings(:one)
  end

  test "visiting the index" do
    visit search_rankings_url
    assert_selector "h1", text: "Search rankings"
  end

  test "should create search ranking" do
    visit search_rankings_url
    click_on "New search ranking"

    click_on "Create Search ranking"

    assert_text "Search ranking was successfully created"
    click_on "Back"
  end

  test "should update Search ranking" do
    visit search_ranking_url(@search_ranking)
    click_on "Edit this search ranking", match: :first

    click_on "Update Search ranking"

    assert_text "Search ranking was successfully updated"
    click_on "Back"
  end

  test "should destroy Search ranking" do
    visit search_ranking_url(@search_ranking)
    click_on "Destroy this search ranking", match: :first

    assert_text "Search ranking was successfully destroyed"
  end
end
