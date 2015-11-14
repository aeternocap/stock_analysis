class Dividend < ActiveRecord::Migration
  def change

    create_table :dividends do |t|
      t.integer     :stock_id
      t.date        :issue_date
      t.decimal     :amount, :precision => 8, :scale => 2
      t.timestamps
    end

    add_index :stocks, :symbol
    add_index :dividends, :stock_id

  end
end
