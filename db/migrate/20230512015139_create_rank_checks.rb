class CreateRankChecks < ActiveRecord::Migration[7.0]
  def change
    create_table :rank_checks do |t|
      t.string :url, comment: "検知URL"
      t.string :keyword, comment: "検索ワード"
      t.integer :gsp_rank, comment: "GoogleSPランキング"
      t.datetime :get_date, comment: "取得日時"
      t.integer :zone_type, default:"0", comment: "時間帯"
      t.references :site, null: false, foreign_key: true

      t.timestamps
    end
  end
end
