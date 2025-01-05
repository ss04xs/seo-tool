module Batch
  class MeoDataCreate
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
  
      queries = Query.for_search_type_one.order(id: :desc)

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

        require 'selenium-webdriver'

        # ブラウザの設定
        driver = Selenium::WebDriver.for :chrome

        # Googleマップを開く
        driver.navigate.to "https://www.google.com/maps"
        sleep 3

        # 検索キーワードを入力
        search_box = driver.find_element(css: '.searchboxinput')
        search_box.send_keys(keyword)
        search_box.send_keys(:return)
        sleep 5

        # 指定した店舗名
        target_name = query.site.name

        # 検索結果のスクロール処理
        results = []
        previous_count = 0
        max_scroll_attempts = 10 # 最大スクロール回数
        target_rank = nil

        max_scroll_attempts.times do
          # 現在の検索結果を取得
          current_results = driver.find_elements(css: 'a.hfpxzc')
          
          # 既存のresultsに新しい要素を追加（重複排除）
          results = current_results | results

          # 指定した店舗名がリスト内にあるかチェック
          results.each_with_index do |result, index|
            name = result.attribute('aria-label') rescue nil
            if name == target_name
              target_rank = index + 1
              break
            end
          end

          # 見つかったら終了
          break if target_rank

          # 新しい結果が見つからなければ終了
          break if results.size == previous_count

          # スクロール実行
          results.last.location_once_scrolled_into_view
          sleep 2
          
          previous_count = results.size
        end

        # 結果の出力
        if target_rank
          #puts "#{target_name} は検索結果で #{target_rank} 番目に表示されています。"
          query.ranks.create(map_rank: target_rank)
        else
          #puts "#{target_name} は検索結果に見つかりませんでした。"
        end

        # ブラウザを閉じる
        driver.quit
        success += 1
        create_last_time = Time.now
         # Google検索クエリの組み立て
        driver.quit
        sleep(60+rand(10))
      end
      # ブラウザを終了
      #driver.quit

      file = File.new("create_log.txt","a")
      text = "#{success}件のデータを作成しました"
      text += "作成日時は#{create_last_time}です"
      text += "=========="
      file.puts(text)
    end
  end
end