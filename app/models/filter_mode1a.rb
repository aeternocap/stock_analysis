class FilterMode1a < FilterBase
  def mode_filter(query)
    query.where("price / book_val <= 1  ")
      .where("pe_ratio <= 10")
      .where("profit_margin > 0")  
      .where("five_year_avg_yield > 0")      
      .where("trailing_annual_yield > 0")
      .where("price < (fify_two_week_high - fify_two_week_low) * 0.5 + fify_two_week_low")
      .where("total_equity_5 > total_equity_3")
      .where("total_equity_5 > total_equity_1")
  end
end