class StocksController < ApplicationController

  def index
    @display_mode = display_mode
    @sector       = sector
    @industry     = industry
    @total_count  = Stock.fetch_count(display_mode, sector, industry)
    @page_count   = Stock.fetch_page_count(display_mode, sector, industry)
    @current_page = current_page

    @stocks       = Stock.fetch_mode(display_mode, sector, industry, current_page)
  end

  def display_mode
    params["mode"]
  end

  def sector
    params["sector"]
  end

  def industry
    params["industry"]
  end

  def current_page
    params["current_page"].to_i
  end
end
