class FilterMarketLeader < FilterBase
  def mode_filter(query)
    if has_industry? && has_sector?
      results = laser_focus_mode(query)
    else
      results = overview_mode(query)
    end

    unless results.size == 0
      query = query.where(id: results.map(&:id))
    else
      query = query.where(id: 0)
    end
    query
    
  end

  def ordering(query)
    query = query.order("sector ASC")
    query = query.order("industry ASC")
  end  

  def overview_mode(query)
    interim_query = query
      .where("book_val > 0")
      .where("price > 0")

    
    if !has_sector?
      interim_query = interim_query.group("sector") 
    else
      interim_query = interim_query.group("sector") 
    end
    interim_query = interim_query.group("industry") if !has_industry?
    interim_query
          
  end

  def laser_focus_mode(query)
    results = query
      .where("book_val > 0")
      .where("price > 0")
      .order("profit_margin DESC")
      .limit(1)        
  end


end