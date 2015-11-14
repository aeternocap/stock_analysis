class FilterMode7 < FilterBase
  def mode_filter(query)
    query.where("price / book_val <= 1")
      .where("pe_ratio <= 10")
      .where("five_year_avg_yield > 0")
      .where("trailing_annual_yield > 0")
      .order("five_year_avg_yield DESC")
  end
end