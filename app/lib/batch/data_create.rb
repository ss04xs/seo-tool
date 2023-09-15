class Batch::DataCreate
    def self.data_create
      success = 0
      error = 0
      p "#{success}件のデータを作成しました"
      p "エラーは#{error}件です"
    end

    def self.rank_data_create
      require 'nokogiri'
      require 'open-uri'
      require 'uri'
      require 'cgi'
      require 'webrick/httputils'
  
      queries = Query.all

      success = 0
      create_last_time = ""
  
      queries.each do |query|
        keyword = query.keyword
        query_url = query.url
        @subject_array = []

        @div_serch = "P8ujBc v5yQqb jqWpsc"
        @title_serch = "A9xod ynAwRc q8U8x MBeuO oewGkc LeUQr"

        # Google検索クエリの組み立て
        sleep(70+rand(10))
        # Google検索クエリの組み立て
        url = "https://www.google.co.jp/search?q=#{keyword}&num=100"
        url_escape = WEBrick::HTTPUtils.escape(url)
        user_agent = 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/91.0.4472.80 Mobile/15E148 Safari/604.1'
  
        # Google検索結果からタイトルとURLを抽出(nokogiriライブラリを利用)
        doc = Nokogiri::HTML(URI.open(url_escape, "User-Agent" => user_agent))
        doc.search("//div[@class='#{@div_serch}']").each.with_index(1) do | div_rc,i |
          url = ""
          #title = div_rc.search('h3[@class="zBAuLc l97dzf"]')[0].text # タイトルを抽出
          title = div_rc.search("div[@class='#{@title_serch}']") # タイトルを抽出
          search_a = div_rc.search('a')
          if search_a.present?
            get_url = search_a[0]["href"] # URLを抽出
            text = ""
            text = title.text if title.present?
            if get_url.include?(query_url)
              @subject_array << [i,get_url]
            end
          else
            url = ""
          end
        end
        if @subject_array[0].present?
          gsp_rank = @subject_array[0][0]
          gsp_url = @subject_array[0][1]
        else
          gsp_rank = ""
          gsp_url = ""
        end
        query.ranks.create(gsp_rank: gsp_rank,detection_url:gsp_url)
        success += 1
        create_last_time = Time.now
      end
      p "#{success}件のデータを作成しました"
      p "再取得作成日時は#{create_last_time}です"
      p "=========="
    end
end