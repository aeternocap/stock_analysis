class AddMarketCapToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :market_cap, :float
  end
end
