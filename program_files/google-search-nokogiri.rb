# スクレイピングに利用するライブラリをインポート
require 'nokogiri'
require 'open-uri'
require 'uri'
require 'cgi'
require 'webrick/httputils'

# Google検索の結果をスクレイピング する関数
def searchKeywordWithGoogle(keyword)
  pageList = []

  # Google検索クエリの組み立て
  url = "https://www.google.co.jp/search?q=#{keyword}&num=100"
  #url_escape = URI.escape(url)
  url_escape = WEBrick::HTTPUtils.escape(url)
  user_agent = 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.63 Safari/537.36'
  charset = nil

  doc = Nokogiri::HTML(URI.open(url_escape))

  # Google検索を実施
  html = URI.open(url_escape, "User-Agent" => user_agent) do |f|
    charset = f.charset
    f.read
  end

  # Google検索結果からタイトルとURLを抽出(nokogiriライブラリを利用)
  doc = Nokogiri::HTML.parse(html)
  doc.search('//div[@class="j039Wc"]').each do | div_rc |
    title = div_rc.search('h3[@class="zBAuLc l97dzf"]')[0].text # タイトルを抽出
    url   = div_rc.search('a')[0]["href"] # URLを抽出
    tmpArray = [url, title]
    pageList << tmpArray
  end
  sleep(1)
  return pageList
end

google_search_keyword = "Ruby Google検索" # Googleで検索したいワード(適宜変更)
ret = searchKeywordWithGoogle(google_search_keyword)
ret.each do |list|
  puts list[0] # タイトルを抽出
  puts list[1] # URLを抽出
  puts "------"
end
