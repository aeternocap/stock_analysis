require 'rake'
Stocker::Application.load_tasks  

class StockSyncerUs
  include Sidekiq::Worker
  sidekiq_options queue: :low, retry: 3

  def perform()
    Rake::Task["db:suck_us"].reenable
    Rake::Task["db:suck_us"].invoke
  end

end