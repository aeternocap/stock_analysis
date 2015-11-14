# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151114171656) do

  create_table "dividends", force: true do |t|
    t.integer  "stock_id"
    t.date     "issue_date"
    t.decimal  "amount",     precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "issue_year"
  end

  add_index "dividends", ["stock_id"], name: "index_dividends_on_stock_id", using: :btree

  create_table "stocks", force: true do |t|
    t.string   "sector"
    t.string   "industry"
    t.string   "company"
    t.float    "price"
    t.float    "book_val"
    t.float    "price_book_ratio"
    t.float    "pe_ratio"
    t.float    "current_ratio"
    t.float    "profit_margin"
    t.float    "return_on_assets"
    t.float    "return_on_equity"
    t.float    "five_year_avg_yield"
    t.float    "forward_annual_yield"
    t.float    "trailing_annual_yield"
    t.float    "fify_two_week_high"
    t.float    "fify_two_week_low"
    t.string   "exchange"
    t.string   "company_url"
    t.string   "company_stats_url"
    t.string   "sector_url"
    t.string   "industry_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "symbol"
    t.float    "total_equity_5",           default: 0.0
    t.float    "total_equity_4",           default: 0.0
    t.float    "total_equity_3",           default: 0.0
    t.float    "total_equity_2",           default: 0.0
    t.float    "total_equity_1",           default: 0.0
    t.float    "total_liability_5",        default: 0.0
    t.float    "total_liability_4",        default: 0.0
    t.float    "total_liability_3",        default: 0.0
    t.float    "total_liability_2",        default: 0.0
    t.float    "total_liability_1",        default: 0.0
    t.float    "total_asset_5",            default: 0.0
    t.float    "total_asset_4",            default: 0.0
    t.float    "total_asset_3",            default: 0.0
    t.float    "total_asset_2",            default: 0.0
    t.float    "total_asset_1",            default: 0.0
    t.float    "market_cap"
    t.string   "market_cap_str"
    t.float    "peg_ratio"
    t.float    "price_sales_ratio"
    t.float    "avg_yield_amount"
    t.float    "avg_yield_percentage"
    t.float    "yield_consistency"
    t.integer  "yield_num_years"
    t.float    "yield_growth_consistency"
  end

  add_index "stocks", ["symbol"], name: "index_stocks_on_symbol", length: {"symbol"=>191}, using: :btree

end
