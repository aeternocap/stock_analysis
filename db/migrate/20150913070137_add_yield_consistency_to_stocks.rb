class AddYieldConsistencyToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :yield_consistency, :float
  end
end
