class RenameUrlToSites < ActiveRecord::Migration[7.0]
  def change
    rename_column :sites, :url, :domain
  end
end
