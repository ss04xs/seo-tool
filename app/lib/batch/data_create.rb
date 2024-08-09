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
      require 'selenium-webdriver'
  
      queries = Query.all.order(id: :desc)

      success = 0
      create_last_time = ""

      #user_agent = 'user-agent=Mozilla/5.0 (iPhone; CPU iPhone OS 14_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/91.0.4472.80 Mobile/15E148 Safari/604.1'
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument('--headless')
      options.add_argument('--disable-gpu')
      options.add_argument('--no-sandbox')
      options.add_argument('--disable-dev-shm-usage')
      #options.add_argument('user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36')

      text = "#{queries.size}のデータを処理します\n"

      user_agents = [
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.93 Safari/537.36',
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.107 Safari/537.36',
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.114 Safari/537.36',
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.90 Safari/537.36',
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.150 Safari/537.36',
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.106 Safari/537.36',
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.85 Safari/537.36',
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.131 Safari/537.36',
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.82 Safari/537.36'
      ]

      count =0
      

      queries.each do |query|
        count += 1
        keyword = query.keyword
        query_url = query.url
        @subject_array = []

        puts "#{keyword}の検索を開始します"

        user_agent = user_agents.sample
        options.add_argument("user-agent=#{user_agent}")

        driver = Selenium::WebDriver.for :chrome, options: options


        # Google検索クエリの組み立て
        # URLを開く
        url = "https://www.google.co.jp/search?q=#{keyword}&num=100"
        driver.get(url)

        # ページのHTMLを取得
        html = driver.page_source
        target_css = "div.g"

        # NokogiriでHTMLをパース
        @doc = Nokogiri::HTML(html)

        @doc.css(target_css).each.with_index(1) do |result,i|
          url = ""
          #title = div_rc.search('h3[@class="zBAuLc l97dzf"]')[0].text # タイトルを抽出
          title = result.css('h3').text
          text += "#{count}回目#{i}// == #{keyword} == #{title}です\n"
          puts "#{count}回目#{i}// == #{keyword} == #{title}です\n"
          link = result.css('a').first
          get_url = link['href'] if link
          if get_url.present?
            if get_url.include?(query_url)
              @subject_array << [i,get_url]
            end
          else
            url = ""
          end
        end
        puts "#{count}回目のキーワード処理を実行しました。"
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
         # Google検索クエリの組み立て
        driver.quit
        sleep(60+rand(10))
      end
      # ブラウザを終了
      driver.quit

      file = File.new("create_log.txt","a")
      text = "#{success}件のデータを作成しました"
      text += "作成日時は#{create_last_time}です"
      text += "=========="
      file.puts(text)
    end
end