class AddDebtEquityToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :total_debt_equity, :float
  end
end
