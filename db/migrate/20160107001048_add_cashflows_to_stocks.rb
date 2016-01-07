class AddCashflowsToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :operating_activities_cashflow_4, :float
    add_column :stocks, :operating_activities_cashflow_3, :float
    add_column :stocks, :operating_activities_cashflow_2, :float
    add_column :stocks, :operating_activities_cashflow_1, :float
    add_column :stocks, :investing_activities_cashflow_4, :float
    add_column :stocks, :investing_activities_cashflow_3, :float
    add_column :stocks, :investing_activities_cashflow_2, :float
    add_column :stocks, :investing_activities_cashflow_1, :float
    add_column :stocks, :net_cashflow_4, :float
    add_column :stocks, :net_cashflow_3, :float
    add_column :stocks, :net_cashflow_2, :float
    add_column :stocks, :net_cashflow_1, :float    
    add_column :stocks, :cash_per_share, :float    
    
  end
end
