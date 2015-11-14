class AddYearsOfIssuesToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :yield_num_years, :integer
  end
end
