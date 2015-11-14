class Dividend < ActiveRecord::Base
  after_commit :compute_aggregated_dividend

  def compute_aggregated_dividend
    stock = Stock.find stock_id
    stock.compute_yields
  end

end