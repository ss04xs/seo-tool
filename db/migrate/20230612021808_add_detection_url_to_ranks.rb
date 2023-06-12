class AddDetectionUrlToRanks < ActiveRecord::Migration[7.0]
  def change
    add_column :ranks, :detection_url, :string, comment: "検知URL"
  end
end
