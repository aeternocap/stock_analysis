class FilterPeg < FilterBase
  def mode_filter(query)
    query.where("peg_ratio < 1 ")
      .where("peg_ratio > 0 ")
      .where("profit_margin > 0 ")      
      .where("five_year_avg_yield > 10")
      .where("trailing_annual_yield > 10")
      .order("five_year_avg_yield DESC")
  end
end