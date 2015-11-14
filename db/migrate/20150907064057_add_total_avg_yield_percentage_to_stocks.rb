class AddTotalAvgYieldPercentageToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :avg_yield_percentage, :float
  end
end
