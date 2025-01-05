class AddMapRankToRanks < ActiveRecord::Migration[7.0]
  def change
    add_column :ranks, :map_rank, :integer
  end
end
