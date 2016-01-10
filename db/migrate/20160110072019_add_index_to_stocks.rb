class AddIndexToStocks < ActiveRecord::Migration
  def change
    add_index "stocks", [
      "symbol"
    ], name: "sym_search", using: :btree            

    add_index "stocks", [
      "industry"
    ], name: "industry_search", using: :btree                
  end
end
