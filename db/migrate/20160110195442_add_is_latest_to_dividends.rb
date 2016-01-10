class AddIsLatestToDividends < ActiveRecord::Migration
  def change
    add_column :dividends, :is_latest, :boolean
  end
end
