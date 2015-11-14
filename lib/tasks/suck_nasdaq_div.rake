# require 'rake'
# Stocker::Application.load_tasks 
# Rake::Task['db:suck_us'].invoke

require 'csv'
require 'open-uri'
require './lib/tasks/stock_formatter'

namespace :db do
  desc "imports SG stock market CSV data into the database"
  task :suck_nasdaq_div => :environment do
    counter = 0
    datasource_url = "http://data.getdata.io/n66_cb4745e57fa1e82dec099e65de1d36c2eses/csv"
    # datasource_url = "./raw_data/nasdaq_dvdend.csv"
    CSV.foreach( open(datasource_url), :headers => :first_row ).each do |row|

      issue_amount = 0
      issue_amount = row["issue_amount"].to_f unless row["issue_amount"].nil?

      if issue_amount > 0 && row["issue_date"].present? && 
      /[0-9]{1,2}\/[0-9]{1,2}\/[0-9]{1,4}/.match(row["issue_date"])

        issue_date = Date.strptime(row["issue_date"],"%m/%d/%Y")
        issue_amount = row["issue_amount"].to_f
        symbol = row["origin_value"]
        stock_id = Stock.where(symbol: row["origin_value"]).map(&:id).first
        puts "\n\n#{counter}: Checking dividend"
        puts "\tsymbol: #{symbol}"
        puts "\tstock_id: #{stock_id}"
        puts "\tissue_date: #{issue_date}"
        puts "\tissue_amount: #{issue_amount}"

        dividend = Dividend.where(
          stock_id: stock_id,
          issue_date: issue_date,
          amount: issue_amount
        ).first

        if dividend.nil?
          Dividend.create!(
            stock_id: stock_id,
            issue_date: issue_date,
            issue_year: issue_date.year,
            amount: issue_amount
          )
          puts"\tCreating new entry"
        end

        counter += 1

      end

    end

  end  
end