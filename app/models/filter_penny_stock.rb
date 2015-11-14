class FilterPennyStock < FilterBase
  def mode_filter(query)
    query.where("price / book_val <= 0.2")
      .where("total_equity_5 > total_equity_3")
      .where("total_equity_5 > total_equity_1")
      .where("price < 1")
      .where("price > 0")
      .order("price / book_val ASC")
  end
end