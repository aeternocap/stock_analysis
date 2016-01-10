class AddIsActiveToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :is_active, :boolean
  end
end
