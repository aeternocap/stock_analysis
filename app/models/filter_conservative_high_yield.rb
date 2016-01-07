class FilterConservativeHighYield < FilterBase
  def mode_filter(query)
    query.where("price / book_val <= 1 ")
      .where("price / book_val > 0 ")
      .where("pe_ratio <= 10")
      .where("pe_ratio > 0")
      .where("profit_margin > 0 ")
      .where("avg_yield_percentage > 10")
      .where("
        (
          (
            operating_activities_cashflow_4 + 
            investing_activities_cashflow_4
          ) / outstanding_shares
        ) / 
        (
          ( avg_yield_percentage / 4 ) * price
        ) > 1.5
      ")
      .where("yield_consistency > 0.8")
      .where("yield_num_years > 5")
      .order(" ( 1 - price / book_val ) * avg_yield_percentage / 15 * yield_num_years / 10 DESC")
      .order("yield_consistency DESC")
      .order("avg_yield_percentage DESC")
  end
end