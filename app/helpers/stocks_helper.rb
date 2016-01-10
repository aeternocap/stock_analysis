module StocksHelper
  def get_color( col_name )
    col_name = col_name.to_s
    if Stock::RATIOS_COL.include? col_name
      "ratios"
    elsif Stock::YEILD_COL.include?(col_name)
      "yield"
    elsif Stock::GROWTH_COL.include?(col_name)
      "growth"
    elsif Stock::EQUITY_COL.include? col_name
      "equity"
    end
  end

  def get_sectors
    all_sectors = Stock.sectors
    all_sectors.unshift( Stock::SECTOR_NO_FILTER )
  end

  def get_industries( sector )
    sector = nil if sector == Stock::SECTOR_NO_FILTER

    all_industries = Stock.industries(sector)
    all_industries.unshift( Stock::INDUSTRY_NO_FILTER )
  end  

  def get_pages( total_pages )
    (0..total_pages ).to_a
  end

end
