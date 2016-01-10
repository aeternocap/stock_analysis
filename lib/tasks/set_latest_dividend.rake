namespace :db do
  desc "sets the latest dividend for each company"
  task :set_latest_dividend => :environment do 
    total_count = 0
    Stock.find_each do |stk|
      puts "#{stk.id}: Setting latest dividend - #{stk.company}"
      l_dvd = stk.dividends.order(issue_date: :desc).limit(1).first
      unless l_dvd.nil?
        l_dvd.update(is_latest: 1)
      end
    end
  end
end