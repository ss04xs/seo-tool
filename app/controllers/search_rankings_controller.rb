class SearchRankingsController < ApplicationController
  before_action :set_search_ranking, only: %i[ show edit update destroy ]

  require 'nokogiri'
  require 'open-uri'
  require 'uri'
  require 'cgi'
  require 'webrick/httputils'
  require 'selenium-webdriver'

  # GET /search_rankings or /search_rankings.json
  def index
    @page_lists = []
    @subject_array = []
    keyword = params[:keyword]
    query_url = params[:subject_url]

    if keyword.present?
      # Google検索クエリの組み立て
      # Chromeドライバを設定
     # Selenium WebDriverの設定
      user_agent = 'user-agent=Mozilla/5.0 (iPhone; CPU iPhone OS 14_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/91.0.4472.80 Mobile/15E148 Safari/604.1'
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument('--headless')
      options.add_argument('--disable-gpu')
      options.add_argument('--no-sandbox')
      options.add_argument('--disable-dev-shm-usage')
      options.add_argument('user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36')

#      options.add_argument(user_agent)

      driver = Selenium::WebDriver.for :chrome, options: options

      # URLを開く
      url = "https://www.google.co.jp/search?q=#{keyword}&num=100"
      driver.get(url)

      # ページのHTMLを取得
      html = driver.page_source

      target_css = "div.g"

      # NokogiriでHTMLをパース
      @doc = Nokogiri::HTML(html)

      @doc.css(target_css).each.with_index(1) do |result,i|
        link = result.css('a').first
        title = result.css('h3').text
        get_url = link['href'] if link
        if get_url.present?
          if get_url.include?(query_url)
            @subject_array << i
          end
          tmpArray = [title, get_url]
          @page_lists << tmpArray
        end
      end
      driver.quit
      if @subject_array[0].present?
        @gsp_rank = @subject_array[0][0]
        @gsp_url = @subject_array[0][1]
      else
        @gsp_rank = ""
        @gsp_url = ""
      end
      @rank_array = [@gsp_rank,@gsp_url]
    end
  end

  # GET /search_rankings/1 or /search_rankings/1.json
  def show
  end

  # GET /search_rankings/new
  def new
    @search_ranking = SearchRanking.new
  end

  # GET /search_rankings/1/edit
  def edit
  end

  # POST /search_rankings or /search_rankings.json
  def create
    @search_ranking = SearchRanking.new(search_ranking_params)

    respond_to do |format|
      if @search_ranking.save
        format.html { redirect_to search_ranking_url(@search_ranking), notice: "Search ranking was successfully created." }
        format.json { render :show, status: :created, location: @search_ranking }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @search_ranking.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /search_rankings/1 or /search_rankings/1.json
  def update
    respond_to do |format|
      if @search_ranking.update(search_ranking_params)
        format.html { redirect_to search_ranking_url(@search_ranking), notice: "Search ranking was successfully updated." }
        format.json { render :show, status: :ok, location: @search_ranking }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @search_ranking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /search_rankings/1 or /search_rankings/1.json
  def destroy
    @search_ranking.destroy

    respond_to do |format|
      format.html { redirect_to search_rankings_url, notice: "Search ranking was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_search_ranking
      @search_ranking = SearchRanking.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def search_ranking_params
      params.fetch(:search_ranking, {})
    end
end