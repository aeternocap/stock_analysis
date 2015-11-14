class AddMarketCapStrToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :market_cap_str, :string
  end
end
