class AddColumnsToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :total_equity_5, :float, :default => 0
    add_column :stocks, :total_equity_4, :float, :default => 0
    add_column :stocks, :total_equity_3, :float, :default => 0
    add_column :stocks, :total_equity_2, :float, :default => 0
    add_column :stocks, :total_equity_1, :float, :default => 0
    add_column :stocks, :total_liability_5, :float, :default => 0
    add_column :stocks, :total_liability_4, :float, :default => 0
    add_column :stocks, :total_liability_3, :float, :default => 0
    add_column :stocks, :total_liability_2, :float, :default => 0
    add_column :stocks, :total_liability_1, :float, :default => 0
    add_column :stocks, :total_asset_5, :float, :default => 0
    add_column :stocks, :total_asset_4, :float, :default => 0
    add_column :stocks, :total_asset_3, :float, :default => 0
    add_column :stocks, :total_asset_2, :float, :default => 0
    add_column :stocks, :total_asset_1, :float, :default => 0
  end
end
