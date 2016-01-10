class AddDilutedEpsToStockImportLogs < ActiveRecord::Migration
  def change
    add_column :stock_import_logs, :diluted_eps, :float
  end
end
