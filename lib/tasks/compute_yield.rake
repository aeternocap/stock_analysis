namespace :db do
  desc "Computes aggregated yield and health status of yield for all stocks"
  task :compute_yield => :environment do 
    Stock.all.each do |stk|
      puts "Computing yield data for #{stk.id}"
      stk.compute_yields
    end
  end
end