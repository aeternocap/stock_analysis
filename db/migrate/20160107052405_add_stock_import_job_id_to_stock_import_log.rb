class AddStockImportJobIdToStockImportLog < ActiveRecord::Migration
  def change
    add_column :stock_import_logs, :stock_import_job_id, :integer
  end
end
