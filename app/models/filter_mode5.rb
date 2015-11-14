# This method takes into account only increase in assets over the past 3 years
# conservative valuation and
# good liquidity
class FilterMode5 < FilterBase
  def mode_filter(query)
    query.where("price / book_val <= 1")
      .where("pe_ratio <= 10")
      .where("current_ratio > 1")
      .where("price < (fify_two_week_high - fify_two_week_low) * 0.25 + fify_two_week_low")        
      .where("total_equity_5 > total_equity_4")
      .where("total_equity_4 > total_equity_3")
      .where("total_equity_3 > total_equity_2")
      .where("total_equity_2 > total_equity_1")
      .where("total_equity_5 / total_equity_3 >= 2")
  end
end