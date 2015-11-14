require 'rake'
Stocker::Application.load_tasks  

class StockSyncerSgx
  include Sidekiq::Worker
  sidekiq_options queue: :low, retry: 3

  def perform()
    Rake::Task["db:suck_sg"].reenable
    Rake::Task["db:suck_sg"].invoke
  end

end