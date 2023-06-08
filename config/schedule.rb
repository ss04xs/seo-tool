env :PATH, ENV['PATH'] # 絶対パスから相対パス指定
set :output, 'log/cron.log' # ログの出力先ファイルを設定
set :environment, :production

every 1.day, at: ['6:00 pm'] do
    runner 'Batch::DataCreate.rank_data_create'
end