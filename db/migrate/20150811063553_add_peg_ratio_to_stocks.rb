class AddPegRatioToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :peg_ratio, :float
  end
end
