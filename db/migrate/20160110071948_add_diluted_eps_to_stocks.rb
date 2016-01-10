class AddDilutedEpsToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :diluted_eps, :float
  end
end
