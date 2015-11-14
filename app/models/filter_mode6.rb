# This method takes into account only increase in assets over the past 3 years
# conservative valuation and
# good liquidity
class FilterMode6 < FilterBase
  def mode_filter(query)
    query.where("price / book_val <= 1")
      .where("pe_ratio <= 10")
      .where("total_equity_5 > total_equity_3")
      .where("total_equity_5 > total_equity_1")
      .where("five_year_avg_yield > 0")
      .where("trailing_annual_yield > 0")
  end
end