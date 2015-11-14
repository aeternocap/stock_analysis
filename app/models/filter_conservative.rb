class FilterConservative < FilterBase
  def mode_filter(query)
    query.where("price / book_val <= 0.5 ")
      .where("pe_ratio <= 10")
      .where("trailing_annual_yield > 7")
      .where("five_year_avg_yield > 7")
  end
end