class Stocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.string  :sector
      t.string  :industry
      t.string  :company
      t.float   :price
      t.float   :book_val
      t.float   :price_book_ratio
      t.float   :pe_ratio
      t.float   :current_ratio
      t.float   :profit_margin
      t.float   :return_on_assets
      t.float   :return_on_equity
      t.float   :five_year_avg_yield
      t.float   :forward_annual_yield
      t.float   :trailing_annual_yield
      t.float   :fify_two_week_high
      t.float   :fify_two_week_low
      t.string  :exchange
      t.string  :company_url
      t.string  :company_stats_url
      t.string  :sector_url
      t.string  :industry_url
      t.timestamps
    end    
  end
end
