class FilterIncome < FilterBase
  def mode_filter(query)
    query.where("
        (
          (
            operating_activities_cashflow_4 + 
            investing_activities_cashflow_4
          ) / outstanding_shares
        ) / 
        (
          ( avg_yield_percentage / 4 / 100 ) * price
        ) > 2
      ")
      .where("yield_consistency > 0.9")
      .where("profit_margin > 0")
      .where("diluted_eps / ( ( avg_yield_percentage / 4 / 100 ) * price ) > 1 ")
      .where("yield_num_years > 5")
      .where("avg_yield_percentage > 10")
      .order(" 
        ( yield_num_years / 10 ) * 
        (
          (
            (
              operating_activities_cashflow_4 + 
              investing_activities_cashflow_4
            ) / outstanding_shares
          ) / 
          (
            ( avg_yield_percentage / 4 ) * price
          )          
        ) * 
        (
          avg_yield_percentage / 100
        )
        DESC")
      .order("yield_consistency DESC")
      .order("avg_yield_percentage DESC")
  end
end