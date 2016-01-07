# require 'rake'
# Stocker::Application.load_tasks 
# Rake::Task['db:suck_us'].invoke

require 'csv'
require 'open-uri'
require './lib/tasks/stock_formatter'

namespace :db do
  desc "imports US stock market MLP CSV data into the database"
  task :suck_mlp => :environment do 
    counter = 0
    datasource_url = "http://data.getdata.io/n43_b9cc2b528206a3c0f7dbeb1b6d140f64eses/csv"
    CSV.foreach( open(datasource_url), :headers => :first_row ).each do |row|      
      stock = Stock.where(symbol: row["company_symbol"]).first
      create_new = false

      if stock.nil?
        create_new =true
        stock = Stock.create!(
          symbol: row["company_symbol"]
        )        
      end

      stock.exchange          = row["exchange"] unless row["exchange"].nil?
      stock.company_url       = row["company_symbol_origin_url"] unless row["company_symbol_origin_url"].nil?
      stock.company_stats_url = row["statistics page"] unless row["statistics page"].nil?
      stock.sector_url        = row["sector page"] unless row["sector page"].nil?
      stock.industry_url      = row["industry page"] unless row["industry page"].nil?
      
      stock.sector = StockFormatter.to_string(row["sector"])
      stock.industry = StockFormatter.to_string(row["industry"])
      stock.company = StockFormatter.to_string(row["company name"])
      stock.market_cap = StockFormatter.to_non_shorthand(row["market cap"])
      stock.market_cap_str = row["market cap"]
      stock.price = StockFormatter.to_float(row["traded price"])
      stock.book_val = StockFormatter.to_float(row["book value"])
      stock.price_book_ratio = StockFormatter.to_ratio(row["price book ratio"], row["traded price"], row["book value"])
      stock.pe_ratio = StockFormatter.to_float(row["PE ratio"])
      stock.peg_ratio = StockFormatter.to_float(row["PEG ratio"])
      stock.current_ratio = StockFormatter.to_float(row["Current ratio"])
      stock.profit_margin = StockFormatter.to_float(row["Profit Margin"])
      stock.return_on_assets = StockFormatter.to_float(row["Return on Assets"])
      stock.return_on_equity = StockFormatter.to_float(row["Return on Equity"])
      stock.five_year_avg_yield = StockFormatter.to_float(row["5 year average yield"])
      stock.forward_annual_yield = StockFormatter.to_float(row["Forward Annual Dividend Yield"])
      stock.trailing_annual_yield = StockFormatter.to_float(row["Trailing Annual Dividend Yield"])
      stock.fify_two_week_high = StockFormatter.to_float(row["52-Week High"]) 
      stock.fify_two_week_low = StockFormatter.to_float(row["52-Week Low"])

      stock.total_asset_1 = StockFormatter.to_float(row["total_asset_1"])
      stock.total_asset_2 = StockFormatter.to_float(row["total_asset_2"])
      stock.total_asset_3 = StockFormatter.to_float(row["total_asset_3"])
      stock.total_asset_4 = StockFormatter.to_float(row["total_asset_4"])
      stock.total_asset_5 = StockFormatter.to_float(row["total_asset_5"])

      stock.total_liability_1 = StockFormatter.to_float(row["total_liability_1"])
      stock.total_liability_2 = StockFormatter.to_float(row["total_liability_2"])
      stock.total_liability_3 = StockFormatter.to_float(row["total_liability_3"])
      stock.total_liability_4 = StockFormatter.to_float(row["total_liability_4"])
      stock.total_liability_5 = StockFormatter.to_float(row["total_liability_5"])

      stock.total_equity_1 = StockFormatter.to_equity(row["total_equity_1"], stock.total_asset_1, stock.total_liability_1)
      stock.total_equity_2 = StockFormatter.to_equity(row["total_equity_2"], stock.total_asset_2, stock.total_liability_2)
      stock.total_equity_3 = StockFormatter.to_equity(row["total_equity_3"], stock.total_asset_3, stock.total_liability_3)
      stock.total_equity_4 = StockFormatter.to_equity(row["total_equity_4"], stock.total_asset_4, stock.total_liability_4)
      stock.total_equity_5 = StockFormatter.to_equity(row["total_equity_5"], stock.total_asset_5, stock.total_liability_5)

      stock.save!
      counter += 1

      if create_new
        puts "#{counter}: Created - #{stock.company}"
      else
        puts "#{counter}: Updated - #{stock.company}"
      end
    end
  end

end