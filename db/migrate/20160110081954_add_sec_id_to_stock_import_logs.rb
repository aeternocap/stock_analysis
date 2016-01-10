class AddSecIdToStockImportLogs < ActiveRecord::Migration
  def change
    add_column :stock_import_logs, :sec_id, :string
  end
end
