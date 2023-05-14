require "application_system_test_case"

class RankChecksTest < ApplicationSystemTestCase
  setup do
    @rank_check = rank_checks(:one)
  end

  test "visiting the index" do
    visit rank_checks_url
    assert_selector "h1", text: "Rank checks"
  end

  test "should create rank check" do
    visit rank_checks_url
    click_on "New rank check"

    fill_in "Get date", with: @rank_check.get_date
    fill_in "Gsp rank", with: @rank_check.gsp_rank
    fill_in "Keyword", with: @rank_check.keyword
    fill_in "Site id", with: @rank_check.site_id_id
    fill_in "Url", with: @rank_check.url
    fill_in "Zone type", with: @rank_check.zone_type
    click_on "Create Rank check"

    assert_text "Rank check was successfully created"
    click_on "Back"
  end

  test "should update Rank check" do
    visit rank_check_url(@rank_check)
    click_on "Edit this rank check", match: :first

    fill_in "Get date", with: @rank_check.get_date
    fill_in "Gsp rank", with: @rank_check.gsp_rank
    fill_in "Keyword", with: @rank_check.keyword
    fill_in "Site id", with: @rank_check.site_id_id
    fill_in "Url", with: @rank_check.url
    fill_in "Zone type", with: @rank_check.zone_type
    click_on "Update Rank check"

    assert_text "Rank check was successfully updated"
    click_on "Back"
  end

  test "should destroy Rank check" do
    visit rank_check_url(@rank_check)
    click_on "Destroy this rank check", match: :first

    assert_text "Rank check was successfully destroyed"
  end
end
