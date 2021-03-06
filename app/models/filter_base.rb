class FilterBase

  attr_accessor :sector
  attr_accessor :industry

  def initialize(sector=nil, industry=nil)
    self.sector = sector
    self.industry = industry
  end

  def fetch_query
    query = Stock
    query = industry_filter(query)
    query = sector_filter(query)
    query = sanity_filter(query)
    query = mode_filter(query)    
    query = ordering(query)
    query
  end

  def mode_filter(query)
    query.order(" 
        ( 1 - price / book_val ) * avg_yield_percentage / 15 * yield_num_years / 10 * (
          (
            operating_activities_cashflow_4 + 
            investing_activities_cashflow_4
          ) / outstanding_shares
        ) / 
        (
          ( avg_yield_percentage / 4 ) * price
        )
        DESC")
      .order("yield_consistency DESC")
      .order("avg_yield_percentage DESC")    
  end

  def industry_filter(query)
    query = query.where( industry: industry ) if has_industry?
    query
  end

  def has_industry?
    !industry.nil? && industry != Stock::INDUSTRY_NO_FILTER          
  end

  def sector_filter(query)
    query = query.where( sector: sector ) if has_sector?
    query
  end

  def has_sector?
    !sector.nil? && sector != Stock::SECTOR_NO_FILTER
  end

  def sanity_filter(query)
    query = query.where( " book_val > 0" )
    query = query.where( " price > 0" )
    query
  end

  def ordering(query)
    query.order("price_book_ratio ASC")
  end
end