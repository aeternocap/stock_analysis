class Dividend < ActiveRecord::Base
  after_validation :set_is_latest
  after_commit :compute_aggregated_dividend

  def set_is_latest
    latest_date = Dividend.where(stock_id: stock_id).order(issue_date: :desc).limit(1).pluck(:issue_date).first
    if latest_date <= self.issue_date
      Dividend.where(stock_id: stock_id, is_latest: false)
      self.is_latest = true
    else
    end
  end

  def compute_aggregated_dividend
    stock = Stock.find stock_id
    stock.compute_yields
  end

end