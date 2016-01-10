class FilterGrowth < FilterBase
  def mode_filter(query)
    query.where("total_debt_equity < 40 ")
          .where("return_on_equity > 20")    
          .where("total_debt_equity > 0")
          .where("pe_ratio > 0")
          .where("is_active = 1") 
  end
end