class CreateStockImportJob < ActiveRecord::Migration
  def change
    create_table :stock_import_jobs do |t|
      t.integer :total_rows
      t.integer :clean_rows
      t.integer :added_rows
      t.integer :modified_rows
      t.integer :removed_rows
      t.timestamps
    end
  end
end
