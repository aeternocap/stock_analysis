class AddPriceSalesRatioToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :price_sales_ratio, :float
  end
end
