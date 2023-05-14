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
    subject_url = params[:subject_url]
    @subject_array = []

    if keyword.present?

      if false

        require 'google/apis/customsearch_v1'

        searcher = Google::Apis::CustomsearchV1::CustomSearchAPIService.new
        searcher.key = 'AIzaSyAdokoQncJv9cQp-Ibck9jSz4wqHffEAAw'

        startNum = 1;

        @items = []
        3.times {
          results = searcher.list_cses(cx: '442df0be871a7455c', q: keyword, start:startNum)

          results.search_information.total_results

          @items << results.items
          if results.queries.next_page[0].start_index.present?
              #次ページがあれば、取得開始位置を設定
              startNum = results.queries.next_page[0].start_index
          else
              #次ページがなければ、ループを抜ける
              break;
          end
          #logger.debug  @items.size
        }

        @items = @items.flatten

        # items.first.title
        # items.first.snippet
        # items.first.link
        # # Doc: https://developers.google.com/custom-search/docs/structured_data#pagemaps
        # items.first.pagemap['cse_image'].first['src'] if items.first.pagemap['cse_image'].present?

        # logger.debug items

      else

        sleep(10)

        # Google検索クエリの組み立て
        url = "https://www.google.co.jp/search?q=#{keyword}&num=100"
        #url_escape = URI.escape(url)
        url_escape = WEBrick::HTTPUtils.escape(url)
        user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36'
        charset = nil

        doc = Nokogiri::HTML(URI.open(url_escape))

      # Google検索を実施
        html = URI.open(url_escape, "User-Agent" => user_agent) do |f|
          charset = f.charset
          f.read
        end

        # Google検索結果からタイトルとURLを抽出(nokogiriライブラリを利用)
        doc = Nokogiri::HTML.parse(html)
        logger.debug doc
        doc.search('//div[@class="Z26q7c UK95Uc jGGQ5e"]').each.with_index(1) do | div_rc,i |
          url = ""
          logger.debug div_rc
          #title = div_rc.search('h3[@class="zBAuLc l97dzf"]')[0].text # タイトルを抽出
          title = div_rc.search('h3[@class="zBAuLc l97dzf"]') # タイトルを抽出
          logger.debug title
          search_a = div_rc.search('a')
          logger.debug "=========search_a========"
          logger.debug search_a
          if search_a.present?
            logger.debug "=========get_url========"
            get_url = search_a[0]["href"] # URLを抽出
            text = ""
            text = search_a.search('h3').text if search_a.search('h3').present?
            logger.debug text
            logger.debug get_url

            if get_url.include?(subject_url)
              @subject_array << i
            end
            # url_array = get_url.split("&amp;")
            # url_array.each do |text|
            #   url = text if text.include?("url=")
            # end
          else
            url = ""
          end
          #logger.debug url
          tmpArray = [text, get_url]
          @page_lists << tmpArray
        end
      end
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