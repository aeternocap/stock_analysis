class Stock < ActiveRecord::Base

  INDUSTRY_NO_FILTER = "All industries"
  SECTOR_NO_FILTER = "All sectors"
  PER_PAGE = 50

  SUPPORTED_MODES = [
    'no_filter',
    'conservative',
    'conservative_high_yield',    
    'market_leader',
    'mode_1a',
    'mode_1b',
    'mode_2',
    'mode_3',
    'mode_4',
    'mode_5',
    'mode_6',
    'mode_7',
    'mining_penny_stocks',
    'pe_ratio_lower_10',
    'pe_ratio_upper_10',
    'peg_ratio',   
    'cheap_picks',
    'growth_stocks'
  ]

  DISPLAY_ATTRIBUTES = [
    'sector',
    'industry',    
    'company',
    'symbol',    
    'company_stats_url',
    'attractive_x',
    'price',
    'book_val',
    'price_book_ratio',
    'price_sales_ratio',
    'pe_ratio',
    'peg_ratio',
    'current_ratio',
    'profit_margin',
    'market_cap_str',    
    'fify_two_week_high',
    'fify_two_week_low',
    'total_equity_5',
    'total_equity_4',
    'total_equity_3',
    'total_equity_2',
    'total_equity_1',
    'yield_num_years',    
    'yield_consistency',      
    'avg_yield_percentage',
    'five_year_avg_yield',    
    'forward_annual_yield',
    'trailing_annual_yield',
    'exchange'
  ]

  RATIOS_COL = [
    'attractive_x',
    'price',
    'book_val',
    'price_book_ratio',
    'price_sales_ratio',
    'pe_ratio',
    'peg_ratio',
    'current_ratio',
    'profit_margin',
    'market_cap_str'    
  ]

  YEILD_COL = [
    'yield_num_years',
    'avg_yield_percentage',
    'yield_consistency',
    'five_year_avg_yield',    
    'forward_annual_yield',
    'trailing_annual_yield'
  ]

  EQUITY_COL = [
    'fify_two_week_high',
    'fify_two_week_low',
    'total_equity_5',
    'total_equity_4',
    'total_equity_3',
    'total_equity_2',
    'total_equity_1'    
  ]

  BIG_NUMBER_ATTRIBUTES = [
    'total_equity_5',
    'total_equity_4',
    'total_equity_3',
    'total_equity_2',
    'total_equity_1'    
  ]

  URL_ATTRIBUTES = [
    'company_stats_url'
  ]

  class << self

    def sectors
      Stock.uniq.pluck(:sector).reject { |sector|
        sector == nil ||
        sector == "N/A"
      }
    end

    def industries(sector = nil)
      query = Stock
      query = query.where( sector: sector ) if !sector.nil?
      query = query.uniq.pluck(:industry)
    end

    def fetch_mode(mode, sector = nil, industry = nil, page = 0)
      query = self.fetch_query( mode, sector, industry )
      query = self.page_filter( query , page )

    end

    def fetch_count(mode, sector = nil, industry = nil)
      self.fetch_query( mode, sector, industry ).size
    end

    def fetch_page_count(mode, sector = nil, industry = nil)
      self.fetch_query( mode, sector, industry ).size / Stock::PER_PAGE
    end

    def fetch_filter(mode, sector, industry)
      case mode
      when "conservative"
        FilterConservative.new(sector, industry)
      when "mode_1a"
        FilterMode1a.new(sector, industry)        
      when "mode_1b"
        FilterMode1b.new(sector, industry)        
      when "mode_2"
        FilterMode2.new(sector, industry)
      when "mode_3"
        FilterMode3.new(sector, industry)
      when "mode_4"
        FilterMode4.new(sector, industry)
      when "mode_5"
        FilterMode5.new(sector, industry)
      when "mode_6"
        FilterMode6.new(sector, industry)        
      when "mode_7"
        FilterMode7.new(sector, industry)
      when "growth_stocks"
        FilterGrowth.new(sector, industry)                
      when "market_leader"
        FilterMarketLeader.new(sector, industry)
      when "mining_penny_stocks"
        FilterPennyStock.new(sector, industry)
      when "peg_ratio"
        FilterPeg.new(sector, industry)
      when "conservative_high_yield"
        FilterConservativeHighYield.new(sector, industry)        
      when "cheap_picks"
        FilterCheapPicks.new(sector, industry)                
      when "no_filter"
        FilterBase.new(sector, industry)
      else
        FilterBase.new(sector, industry)
      end
    end

    def fetch_query(mode, sector = nil, industry = nil)
      filter = fetch_filter mode, sector, industry
      query = filter.fetch_query
      query
    end

    def default_filters(query)
      query
        .where( " book_val > 0" )
        .where( " price > 0" )
    end

    def page_filter( query, page = 0)
      page = 0 if page.nil?
      curr_offset = page * Stock::PER_PAGE
      query
        .limit( Stock::PER_PAGE )
        .offset( curr_offset )
    end

    def pe_ratio_lower_10(query)
      non_empty_query = query.where("pe_ratio > 0")
      total_stocks = non_empty_query.size
      cut_off = total_stocks / 10

      cut_off_pe = 0
      stock = non_empty_query
        .where("pe_ratio > 0")
        .order("pe_ratio ASC")
        .limit(cut_off)
        .last
      cut_off_pe = stock.pe_ratio if !stock.nil?
      non_empty_query.where("pe_ratio < ?", cut_off_pe)
    end

  end

  def attractive_x
    discount_factor = 0
    discount_factor = 1 - price / book_val if price.present? && book_val.present?

    consistency_factor = 0
    consistency_factor = yield_num_years / 10.0 if yield_num_years.present?

    yield_factor = 0
    yield_factor = avg_yield_percentage / 15 if avg_yield_percentage.present?
    ( discount_factor * yield_factor * consistency_factor ).round( 2 )
  end

  def to_params
    params = {}
    DISPLAY_ATTRIBUTES.each do |key|
      params[key.to_sym] = self.send(key)
    end
    params
  end

  def compute_yields
    compute_five_year_dividend_yield
    compute_avg_dividend_yield
    compute_dividend_consistency
    compute_dividend_growth_consistency
  end

  # Computes the consistency of annual dividends disbursement since stock first start giving dividends
  def compute_dividend_consistency
    total_years = compute_dividend_year_series.size
    issued_years = Dividend.where(stock_id: id).distinct(:issue_year).pluck(:issue_year)
    return 0 if total_years == 0
    consistency = 1.0 * issued_years.size / total_years
    update(
      yield_consistency: consistency, 
      yield_num_years: total_years
    )
  end

  # Computes how consistent were the growth of the dividends
  # 
  # Total = 
  #   For each year if dividend was more than or equals to the previous year + 1
  #   For each year if dividend was less than the previous year + 0
  #   For each year if dividend was not issue than - 1
  # consistency = Total / Total_number_of_years
  def compute_dividend_growth_consistency
    year_series = compute_dividend_year_series 
    return 0 if year_series.size == 0

    dividends = Dividend.where(stock_id: id).distinct(:issue_year).order(issue_year: :asc)
    dvd_by_year = dividends.group_by(&:issue_year)
    dvd_tot_by_year = {}
    dvd_by_year.each { |year, dvds|
      dvd_tot_by_year[year] = dvds.map { |dvd|
          dvd.amount.to_f
        }.inject{|sum,x| sum + x }
    }
    total_score = 0
    first_year = dvd_tot_by_year.first.first
    prev_divid = dvd_tot_by_year.first.second
    year_series.each { |year|
      if year != first_year

        if !dvd_tot_by_year[year].present?
          total_score -= 1

        elsif dvd_tot_by_year[year] >= prev_divid
          total_score += 1
          prev_divid = dvd_tot_by_year[year]

        elsif dvd_tot_by_year[year] < prev_divid
          total_score += 0
          prev_divid = dvd_tot_by_year[year]
        end
      end
    }
    update(
      yield_growth_consistency: total_score * 1.0 / year_series.size
    )    
  end

  def compute_dividend_year_series
    issued_years = Dividend.where(stock_id: id).distinct(:issue_year).order(issue_year: :asc).pluck(:issue_year)
    return [] if issued_years.size == 0
    current_year = Time.now.year
    earliest_year = issued_years.first
    (earliest_year..current_year).to_a
  rescue Exception => error
    binding.pry
  end

  # Computes the average yield for all time based on current price
  def compute_avg_dividend_yield
    divs = Dividend.where(stock_id: id)
    return if divs.size == 0
    total_amount = divs.map(&:amount).inject(:+).to_f
    total_years = divs.group_by(&:issue_year).keys.size
    avg_amount = total_amount / total_years
    avg_yield_percentage = ( avg_amount / price ) * 100
    update(avg_yield_amount: avg_amount, avg_yield_percentage: avg_yield_percentage)
  end

  # Computes the average yield for the past 5 years based on current price
  def compute_five_year_dividend_yield
    start_date = Time.now - 5.years
    divs = Dividend.where(stock_id: id).where( "issue_date > ? ", start_date)
    return if divs.size == 0

    total_amount = divs.map(&:amount).inject(:+).to_f
    total_years = divs.group_by(&:issue_year).keys.size
    avg_amount = total_amount / total_years
    avg_yield_percentage = ( avg_amount / price ) * 100
    update(five_year_avg_yield: avg_yield_percentage )    
  end

end
