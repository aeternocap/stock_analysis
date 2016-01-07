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

ActiveRecord::Schema.define(version: 20160107060013) do

  create_table "dividends", force: true do |t|
    t.integer  "stock_id"
    t.date     "issue_date"
    t.decimal  "amount",     precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "issue_year"
  end

  add_index "dividends", ["stock_id"], name: "index_dividends_on_stock_id", using: :btree

  create_table "stock_import_jobs", force: true do |t|
    t.integer  "total_rows"
    t.integer  "clean_rows"
    t.integer  "added_rows"
    t.integer  "modified_rows"
    t.integer  "removed_rows"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stock_import_logs", force: true do |t|
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
    t.float    "total_equity_5"
    t.float    "total_equity_4"
    t.float    "total_equity_3"
    t.float    "total_equity_2"
    t.float    "total_equity_1"
    t.float    "total_liability_5"
    t.float    "total_liability_4"
    t.float    "total_liability_3"
    t.float    "total_liability_2"
    t.float    "total_liability_1"
    t.float    "total_asset_5"
    t.float    "total_asset_4"
    t.float    "total_asset_3"
    t.float    "total_asset_2"
    t.float    "total_asset_1"
    t.float    "market_cap"
    t.string   "market_cap_str"
    t.float    "peg_ratio"
    t.float    "price_sales_ratio"
    t.float    "avg_yield_amount"
    t.float    "avg_yield_percentage"
    t.float    "yield_consistency"
    t.integer  "yield_num_years"
    t.float    "yield_growth_consistency"
    t.float    "operating_activities_cashflow_4"
    t.float    "operating_activities_cashflow_3"
    t.float    "operating_activities_cashflow_2"
    t.float    "operating_activities_cashflow_1"
    t.float    "investing_activities_cashflow_4"
    t.float    "investing_activities_cashflow_3"
    t.float    "investing_activities_cashflow_2"
    t.float    "investing_activities_cashflow_1"
    t.float    "net_cashflow_4"
    t.float    "net_cashflow_3"
    t.float    "net_cashflow_2"
    t.float    "net_cashflow_1"
    t.float    "cash_per_share"
    t.float    "total_debt_equity"
    t.float    "outstanding_shares"
    t.integer  "stock_import_job_id"
  end

  add_index "stock_import_logs", ["stock_import_job_id", "symbol"], name: "fast_find", length: {"stock_import_job_id"=>nil, "symbol"=>191}, using: :btree

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
    t.float    "total_equity_5",                  default: 0.0
    t.float    "total_equity_4",                  default: 0.0
    t.float    "total_equity_3",                  default: 0.0
    t.float    "total_equity_2",                  default: 0.0
    t.float    "total_equity_1",                  default: 0.0
    t.float    "total_liability_5",               default: 0.0
    t.float    "total_liability_4",               default: 0.0
    t.float    "total_liability_3",               default: 0.0
    t.float    "total_liability_2",               default: 0.0
    t.float    "total_liability_1",               default: 0.0
    t.float    "total_asset_5",                   default: 0.0
    t.float    "total_asset_4",                   default: 0.0
    t.float    "total_asset_3",                   default: 0.0
    t.float    "total_asset_2",                   default: 0.0
    t.float    "total_asset_1",                   default: 0.0
    t.float    "market_cap"
    t.string   "market_cap_str"
    t.float    "peg_ratio"
    t.float    "price_sales_ratio"
    t.float    "avg_yield_amount"
    t.float    "avg_yield_percentage"
    t.float    "yield_consistency"
    t.integer  "yield_num_years"
    t.float    "yield_growth_consistency"
    t.float    "operating_activities_cashflow_4"
    t.float    "operating_activities_cashflow_3"
    t.float    "operating_activities_cashflow_2"
    t.float    "operating_activities_cashflow_1"
    t.float    "investing_activities_cashflow_4"
    t.float    "investing_activities_cashflow_3"
    t.float    "investing_activities_cashflow_2"
    t.float    "investing_activities_cashflow_1"
    t.float    "net_cashflow_4"
    t.float    "net_cashflow_3"
    t.float    "net_cashflow_2"
    t.float    "net_cashflow_1"
    t.float    "cash_per_share"
    t.float    "total_debt_equity"
    t.float    "outstanding_shares"
  end

  add_index "stocks", ["symbol"], name: "index_stocks_on_symbol", length: {"symbol"=>191}, using: :btree

end
