class Stock < ActiveRecord::Base

  after_validation :compute_yields
  has_many :dividends, dependent: :destroy

  INDUSTRY_NO_FILTER = "All industries"
  SECTOR_NO_FILTER = "All sectors"
  PER_PAGE = 50

  SUPPORTED_MODES = [
    'no_filter',
    'conservative_high_yield',
    'income',    
    'growth_stocks',
    'turn_around',
    'market_leader',
    'mining_penny_stocks',
    'pe_ratio_lower_10',
    'pe_ratio_upper_10',
    'peg_ratio',   
    'cheap_picks',

    'warren'
  ]

  DISPLAY_ATTRIBUTES = [
    'sector',
    'industry',    
    'company',
    'symbol',    
    'company_stats_url',
    'attractive_growth',
    'price_book_ratio',
    'total_debt_equity',
    'return_on_equity', 
    'doubling_factor',
    'profit_margin',    
    'return_on_assets',
    'price_sales_ratio',
    'pe_ratio',
    'peg_ratio',    
    'attractive_div',       
    'free_cashflow_dividend_coverage',            
    'yield_consistency',
    'yield_num_years', 
    'diluted_eps',
    'free_cashflow_per_share',    
    'latest_dividend_issue_amt',    
    'average_dividend_per_quarter_amt',
    'actual_yield_percentage',    
    'avg_yield_percentage',
    'five_year_avg_yield',    
    'forward_annual_yield',
    'trailing_annual_yield',
    'price',
    'book_val',
    'current_ratio',
    'market_cap',        
    'fify_two_week_high',
    'fify_two_week_low',
    'total_equity_5',
    'total_equity_4',
    'total_equity_3',
    'total_equity_2',
    'total_equity_1',    
    'exchange'
  ]

  GROWTH_COL = [
    'attractive_growth',    
    'price_book_ratio',
    'profit_margin',        
    'total_debt_equity',    
    'return_on_equity',
    'doubling_factor',
    'return_on_assets',
    'price_sales_ratio',
    'pe_ratio',
    'peg_ratio'    
  ]


  RATIOS_COL = [
    'price',
    'book_val',
    'current_ratio',
    'market_cap'    
  ]

  YEILD_COL = [
    'attractive_div',        
    'yield_num_years',
    'free_cashflow_dividend_coverage',    
    'free_cashflow_per_share',
    'diluted_eps',
    'latest_dividend_issue_amt',    
    'average_dividend_per_quarter_amt',
    'actual_yield_percentage',
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
    'total_equity_1',
    'market_cap'
  ]

  URL_ATTRIBUTES = [
    'company_stats_url'
  ]

  class << self

    def sectors
      Rails.cache.fetch("sectors", expires_in: 1.week) do
        Stock.uniq.order( sector: :asc ).pluck(:sector).reject { |sector|
          sector == nil ||
          sector == "N/A"
        }
      end      
    end

    def industries(sector = nil)
      Rails.cache.fetch("industries/#{sector}", expires_in: 1.week) do
        query = Stock
        query = query.where( sector: sector ) if !sector.nil?
        query = query.order( industry: :asc )
        query = query.uniq.pluck(:industry)
      end
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
      when "turn_around"
        FilterTurnAround.new(sector, industry)
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
      when "income"
        FilterIncome.new(sector, industry)        
      when 'warren'
        FilterWarren.new(sector, industry)        
      when "no_filter"
        FilterBase.new(sector, industry)
      else
        FilterBase.new(sector, industry)
      end
    end

    def fetch_query(mode, sector = nil, industry = nil)
      filter = fetch_filter mode, sector, industry
      query = filter.fetch_query
      query.includes(:dividends)
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

  def attractive_growth
    return 0 if book_val.nil? || return_on_equity.nil? || total_debt_equity.nil?
    pb_ratio = price / book_val 
    return doubling_factor / pb_ratio / total_debt_equity
  end

  def doubling_factor
    asset_double_years = 70 / return_on_equity
  end

  def attractive_div
    consistency_factor = 0
    consistency_factor = yield_num_years / 10.0 if yield_num_years.present?

    yield_factor = 0
    yield_factor = avg_yield_percentage / 100 if avg_yield_percentage.present?

    free_cashflow_factor = free_cashflow_dividend_coverage

    ( yield_factor * consistency_factor * free_cashflow_factor ).round( 2 )
  end  

  # Returns the free cash flow for the most recent quarter
  def free_cashflow
    fcf = 0
    fcf += operating_activities_cashflow_4 if operating_activities_cashflow_4.present?
    fcf += investing_activities_cashflow_4 if investing_activities_cashflow_4.present?
    fcf
  end

  def free_cashflow_per_share
    if free_cashflow.present? && outstanding_shares.present? && outstanding_shares > 0
      ( free_cashflow / outstanding_shares ).round(2)
    else
      0
    end
  end

  def latest_dividend_issue_amt
    dividends.where(is_latest: 1).pluck(:amount).first.to_f
  end

  def average_dividend
    if avg_yield_percentage.present? && avg_yield_percentage > 0
      price * avg_yield_percentage / 100
    else
      0
    end
  end

  def actual_yield_percentage
    ( latest_dividend_issue_amt * 4 / price * 100 ).round(2)
  end

  def average_dividend_per_quarter_amt
    if avg_yield_percentage.present? && avg_yield_percentage > 0
      ( price * avg_yield_percentage / 100 / 4 ).round(2)
    else
      0
    end
  end  

  def free_cashflow_dividend_coverage
    if average_dividend > 0
      free_cashflow_per_share / average_dividend_per_quarter_amt
    else
      0
    end
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
    self.yield_consistency = consistency
    self.yield_num_years = total_years
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
    self.yield_growth_consistency = total_score * 1.0 / year_series.size 
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
    self.avg_yield_amount = avg_amount
    self.avg_yield_percentage = avg_yield_percentage
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
    self.five_year_avg_yield = avg_yield_percentage
  end

end
