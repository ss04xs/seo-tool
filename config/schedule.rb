env :PATH, ENV['PATH'] # 絶対パスから相対パス指定
set :output, 'log/cron.log' # ログの出力先ファイルを設定
set :environment, :development # 環境を設定

every 1.minute do # 1分毎に実行
  # 「Book」モデルの、「self.create_book」メソッドを実行
  runner 'Batch::DataCreate.data_create'
end