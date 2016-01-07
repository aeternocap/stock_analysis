class AddIndexesToStockImportLogs < ActiveRecord::Migration
  def change
    add_index "stock_import_logs", [
      "stock_import_job_id",
      "symbol"
    ], name: "fast_find", using: :btree            
  end
end
