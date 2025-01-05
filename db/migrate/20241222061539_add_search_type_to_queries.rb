class AddSearchTypeToQueries < ActiveRecord::Migration[7.0]
  def change
    add_column :queries, :search_type, :integer, default: 0, null: false # 0: 通常検索, 1: Googleマップ検索
  end
end
