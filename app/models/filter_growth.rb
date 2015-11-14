class FilterGrowth < FilterBase
  def mode_filter(query)
    query.where("price / book_val <= 1.2")
      .where("pe_ratio <= 10")
      .where("profit_margin > 0")
      .where("price < (fify_two_week_high - fify_two_week_low) * 0.25 + fify_two_week_low")
      .where("total_equity_5 > total_equity_3 * 1.5")
      .where("total_equity_5 > total_equity_1 * 2")
  end
end