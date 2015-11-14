# The raw data was obtained from 
#   http://sgx.com/JsonRead/JsonData?qryId=RStock&timeout=30&%20noCache=1429763985221.144613.38667725818

namespace :db do
  desc "pulls out the Stock symbols from a raw_data file"
  task :clean_it => :environment do  
    data = File.read("./raw_data/sgx_raw.json")
    clean_stock_symbols = data.scan(/NC:'([a-zA-Z0-9]+)'/)
      .flatten
      .map { |raw_symbol|
        "'" + raw_symbol + ".SI'"
      }.join(",\n")
    File.write('./raw_data/clean_sgx_symbols.txt', clean_stock_symbols)

  end
end