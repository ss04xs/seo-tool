class Rank < ApplicationRecord
  belongs_to :query

  def self.create_rank_data
    require 'nokogiri'
    require 'open-uri'
    require 'uri'
    require 'cgi'
    require 'webrick/httputils'

    queries = Query.all

    queries.each do |query|
      keyword = query.keyword
      query_url = query.url
      subject_array = []
      # Google検索クエリの組み立て
      sleep(100)
      url = "https://www.google.co.jp/search?q=#{keyword}&num=100"
      # Google検索クエリの組み立て
      url = "https://www.google.co.jp/search?q=#{keyword}&num=100"
      url_escape = WEBrick::HTTPUtils.escape(url)
      user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36'

      # Google検索結果からタイトルとURLを抽出(nokogiriライブラリを利用)
      doc = Nokogiri::HTML(URI.open(url_escape, "User-Agent" => user_agent))
      doc.search('//div[@class="Z26q7c UK95Uc jGGQ5e"]').each.with_index(1) do | div_rc,i |
        url = ""
        #title = div_rc.search('h3[@class="zBAuLc l97dzf"]')[0].text # タイトルを抽出
        title = div_rc.search('h3[@class="zBAuLc l97dzf"]') # タイトルを抽出
        search_a = div_rc.search('a')
        if search_a.present?
          get_url = search_a[0]["href"] # URLを抽出
          text = ""
          text = search_a.search('h3').text if search_a.search('h3').present?
          if get_url.include?(query_url)
            subject_array << i
          end
        else
          url = ""
        end
      end
      gsp_rank = subject_array[0]
      query.ranks.create(gsp_rank: gsp_rank)
    end
  end
end
