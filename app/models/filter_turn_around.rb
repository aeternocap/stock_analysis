class FilterTurnAround < FilterBase
  def mode_filter(query)
    query.where("price / book_val <= 0.5 ")
      .where("book_val > 0 ")
      .where("pe_ratio < 10")
      .where("pe_ratio > 0")
      .where("price_sales_ratio < 0.5")
      .where("return_on_equity > 0")
      .where("(
          (
            operating_activities_cashflow_4 + 
            investing_activities_cashflow_4
          ) / outstanding_shares
        ) / price > 1
      ")
  end
end