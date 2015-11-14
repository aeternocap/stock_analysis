class AddTotalAvgYieldToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :avg_yield_amount, :float
  end
end
