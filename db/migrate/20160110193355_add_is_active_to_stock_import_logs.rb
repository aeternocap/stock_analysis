class AddIsActiveToStockImportLogs < ActiveRecord::Migration
  def change
    add_column :stock_import_logs, :is_active, :boolean
  end
end
