class CreateQueries < ActiveRecord::Migration[7.0]
  def change
    create_table :queries do |t|
      t.string :url, null: false, comment: "検知URL"
      t.string :keyword, null: false, comment: "検索ワード"
      t.integer :zone_type, null: false, default:"0", comment: "時間帯"
      t.references :site, null: false, foreign_key: true

      t.timestamps
    end
  end
end
