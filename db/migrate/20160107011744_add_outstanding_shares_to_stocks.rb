class AddOutstandingSharesToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :outstanding_shares, :float
  end
end
