class AddYieldGrowthConsistencyToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :yield_growth_consistency, :float
  end
end
