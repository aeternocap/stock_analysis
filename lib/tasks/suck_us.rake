# require 'rake'
# Stocker::Application.load_tasks 
# Rake::Task['db:suck_us'].invoke

require 'csv'
require 'open-uri'
require './lib/tasks/stock_formatter'

namespace :db do
  desc "imports US stock market CSV data into the database"
  task :suck_us => :environment do 
    counter = 0
    # datasource_url = "http://data.getdata.io/n1_46f10ecc52522fcdaecd5f140a4a2c47eses/csv"
    datasource_url = "./raw_data/yahoo_finance.csv"

    job = StockImportJob.create!

    total_count = 0
    total_added = 0
    total_modified = 0
    total_deleted = 0

    all_hashes = []
    added_hashes = []
    update_id_hashes = []
    modified_hashes = []
    default_batch_size = 1000

    CSV.foreach( open(datasource_url), :headers => :first_row ).each do |row|
      stock_hash = {}      
      stock_hash[:symbol] = row["company_symbol"]      
      stock_hash[:exchange]          = row["exchange"] unless row["exchange"].nil?
      stock_hash[:company_url]       = row["company_symbol_origin_url"] unless row["company_symbol_origin_url"].nil?
      stock_hash[:company_stats_url] = row["statistics page"] unless row["statistics page"].nil?
      stock_hash[:sector_url]        = row["sector page"] unless row["sector page"].nil?
      stock_hash[:industry_url]      = row["industry page"] unless row["industry page"].nil?

      stock_hash[:sector] = StockFormatter.to_string(row["sector"])
      stock_hash[:industry] = StockFormatter.to_string(row["industry"])
      stock_hash[:company] = StockFormatter.to_string(row["company name"])
      stock_hash[:market_cap] = StockFormatter.to_non_shorthand(row["market cap"])
      stock_hash[:market_cap_str] = row["market cap"]
      stock_hash[:price] = StockFormatter.to_float(row["traded price"])
      stock_hash[:book_val] = StockFormatter.to_float(row["book value"])
      stock_hash[:price_book_ratio] = StockFormatter.to_ratio(row["price book ratio"], row["traded price"], row["book value"])
      stock_hash[:price_sales_ratio] = StockFormatter.to_float(row["price sales ratio"])
      stock_hash[:pe_ratio] = StockFormatter.to_float(row["PE ratio"])
      stock_hash[:peg_ratio] = StockFormatter.to_float(row["PEG ratio"])
      stock_hash[:current_ratio] = StockFormatter.to_float(row["Current ratio"])
      stock_hash[:profit_margin] = StockFormatter.to_float(row["Profit Margin"])
      stock_hash[:return_on_assets] = StockFormatter.to_float(row["Return on Assets"])
      stock_hash[:return_on_equity] = StockFormatter.to_float(row["Return on Equity"])
      stock_hash[:five_year_avg_yield] = StockFormatter.to_float(row["5 year average yield"])
      stock_hash[:forward_annual_yield] = StockFormatter.to_float(row["Forward Annual Dividend Yield"])
      stock_hash[:trailing_annual_yield] = StockFormatter.to_float(row["Trailing Annual Dividend Yield"])
      stock_hash[:fify_two_week_high] = StockFormatter.to_float(row["52-Week High"]) 
      stock_hash[:fify_two_week_low] = StockFormatter.to_float(row["52-Week Low"])

      stock_hash[:total_asset_1] = StockFormatter.to_float(row["total_asset_1"]) * 1000
      stock_hash[:total_asset_2] = StockFormatter.to_float(row["total_asset_2"]) * 1000
      stock_hash[:total_asset_3] = StockFormatter.to_float(row["total_asset_3"]) * 1000
      stock_hash[:total_asset_4] = StockFormatter.to_float(row["total_asset_4"]) * 1000
      stock_hash[:total_asset_5] = StockFormatter.to_float(row["total_asset_5"]) * 1000

      stock_hash[:total_liability_1] = StockFormatter.to_float(row["total_liability_1"]) * 1000
      stock_hash[:total_liability_2] = StockFormatter.to_float(row["total_liability_2"]) * 1000
      stock_hash[:total_liability_3] = StockFormatter.to_float(row["total_liability_3"]) * 1000
      stock_hash[:total_liability_4] = StockFormatter.to_float(row["total_liability_4"]) * 1000
      stock_hash[:total_liability_5] = StockFormatter.to_float(row["total_liability_5"]) * 1000

      stock_hash[:total_equity_1] = StockFormatter.to_equity(row["total_equity_1"], stock_hash[:total_asset_1], stock_hash[:total_liability_1]) * 1000
      stock_hash[:total_equity_2] = StockFormatter.to_equity(row["total_equity_2"], stock_hash[:total_asset_2], stock_hash[:total_liability_2]) * 1000
      stock_hash[:total_equity_3] = StockFormatter.to_equity(row["total_equity_3"], stock_hash[:total_asset_3], stock_hash[:total_liability_3]) * 1000
      stock_hash[:total_equity_4] = StockFormatter.to_equity(row["total_equity_4"], stock_hash[:total_asset_4], stock_hash[:total_liability_4]) * 1000
      stock_hash[:total_equity_5] = StockFormatter.to_equity(row["total_equity_5"], stock_hash[:total_asset_5], stock_hash[:total_liability_5]) * 1000

      stock_hash[:operating_activities_cashflow_4] = StockFormatter.to_float(row["operating_activities_cashflow_4"]) * 1000
      stock_hash[:operating_activities_cashflow_3] = StockFormatter.to_float(row["operating_activities_cashflow_3"]) * 1000
      stock_hash[:operating_activities_cashflow_2] = StockFormatter.to_float(row["operating_activities_cashflow_2"]) * 1000
      stock_hash[:operating_activities_cashflow_1] = StockFormatter.to_float(row["operating_activities_cashflow_1"]) * 1000

      stock_hash[:investing_activities_cashflow_4] = StockFormatter.to_float(row["investing_activities_cashflow_4"]) * 1000
      stock_hash[:investing_activities_cashflow_3] = StockFormatter.to_float(row["investing_activities_cashflow_3"]) * 1000
      stock_hash[:investing_activities_cashflow_2] = StockFormatter.to_float(row["investing_activities_cashflow_2"]) * 1000
      stock_hash[:investing_activities_cashflow_1] = StockFormatter.to_float(row["investing_activities_cashflow_1"]) * 1000

      stock_hash[:net_cashflow_4] = StockFormatter.to_float(row["net_cashflow_4"]) * 1000
      stock_hash[:net_cashflow_3] = StockFormatter.to_float(row["net_cashflow_3"]) * 1000
      stock_hash[:net_cashflow_2] = StockFormatter.to_float(row["net_cashflow_2"]) * 1000
      stock_hash[:net_cashflow_1] = StockFormatter.to_float(row["net_cashflow_1"]) * 1000

      stock_hash[:cash_per_share] = StockFormatter.to_float(row["Total Cash Per Share"]) 

      stock_hash[:total_debt_equity] = StockFormatter.to_float(row["Total Debt/Equity "])
      stock_hash[:outstanding_shares] = StockFormatter.to_non_shorthand(row["outstanding_shares"])

      stock_hash[:diluted_eps] = StockFormatter.to_float(row["diluted_eps"])

      stock_hash[:sec_id] = StockFormatter.to_float(row["SEC_ID"])
      stock_hash[:is_active] = StockFormatter.is_recent_year?(row["cashflow_period_4"])


      stock = Stock.where(symbol: row["company_symbol"]).first
      
      total_count += 1      
      if stock.nil?
        total_added += 1
        puts "#{total_count}: Created - #{row['company name']}"
        added_hashes << stock_hash
      else
        puts "#{total_count}: Updated - #{stock.company}"
        update_id_hashes << stock.id
        modified_hashes << stock_hash
        total_modified += 1
      end
      
      stock_log_hash = stock_hash.dup
      stock_log_hash[:stock_import_job_id] = job.id      

      all_hashes << stock_log_hash

      if added_hashes.size >= default_batch_size
        Stock.create(added_hashes)   
        added_hashes = []
      end

      if modified_hashes.size >= default_batch_size
        Stock.update(update_id_hashes, modified_hashes)
        update_id_hashes = []
        modified_hashes = []
      end

      if all_hashes.size >= default_batch_size
        StockImportLog.create(all_hashes)
        all_hashes = []
      end
            
      # counter += 1

      # if counter % 500 == 0
      #   puts "#{counter}"
      #   pp GC.stat
      # end
    end
    StockImportLog.create(all_hashes)
    Stock.create(added_hashes)   
    Stock.update(update_id_hashes, modified_hashes)

    job.total_rows = total_count
    job.clean_rows = total_count
    job.added_rows = total_added
    job.modified_rows = total_modified
    job.removed_rows = StockImportJob.get_total_removed job.id
    job.save!

  end

end