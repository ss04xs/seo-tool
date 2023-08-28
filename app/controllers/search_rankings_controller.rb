class SearchRankingsController < ApplicationController
  before_action :set_search_ranking, only: %i[ show edit update destroy ]

  require 'nokogiri'
  require 'open-uri'
  require 'uri'
  require 'cgi'
  require 'webrick/httputils'

  # GET /search_rankings or /search_rankings.json
  def index
    @page_lists = []
    keyword = params[:keyword]
    query_url = params[:subject_url]
    @subject_array = []

    if keyword.present?
      # Google検索クエリの組み立て
      sleep(10)
      # Google検索クエリの組み立て
      url = "https://www.google.co.jp/search?q=#{keyword}&num=100"
      url_escape = WEBrick::HTTPUtils.escape(url)
      user_agent = 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/91.0.4472.80 Mobile/15E148 Safari/604.1'

      @div_serch = "P8ujBc v5yQqb jqWpsc"
      @title_serch = "A9xod ynAwRc q8U8x MBeuO oewGkc LeUQr"


      # Google検索結果からタイトルとURLを抽出(nokogiriライブラリを利用)
      @doc = Nokogiri::HTML(URI.open(url_escape, "User-Agent" => user_agent))
      @doc.search("//div[@class='#{@div_serch}']").each.with_index(1) do | div_rc,i |
        url = ""
        #title = div_rc.search('h3[@class="zBAuLc l97dzf"]')[0].text # タイトルを抽出
        title = div_rc.search("div[@class='#{@title_serch}']") # タイトルを抽出
        search_a = div_rc.search('a')
        if search_a.present?
          get_url = search_a[0]["href"] # URLを抽出
          text = ""
          text = title.text if title.present?
          if get_url.include?(query_url)
            @subject_array << i
          end
        else
          url = ""
        end
        tmpArray = [text, get_url]
        @page_lists << tmpArray
      end
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