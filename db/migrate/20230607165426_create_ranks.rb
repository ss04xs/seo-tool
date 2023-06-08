class CreateRanks < ActiveRecord::Migration[7.0]
  def change
    create_table :ranks do |t|
      t.integer :gsp_rank, comment: "順位"
      t.references :query, null: false, foreign_key: true

      t.timestamps
    end
  end
end
