class AddSecIdToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :sec_id, :string
  end
end
