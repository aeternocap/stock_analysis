class FilterMode2 < FilterBase
  def mode_filter(query)
      query.where("price / book_val <= 1")
        .where("pe_ratio <= 10")
        .where("five_year_avg_yield > 0")
        .where("trailing_annual_yield > 0")
        .where("current_ratio > 1")
        .where("price < (fify_two_week_high - fify_two_week_low) * 0.25 + fify_two_week_low")
  end
end