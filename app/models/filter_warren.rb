class FilterWarren < FilterBase
  def mode_filter(query)
    symbols = [
      "WFC",
      "KHC",
      "KO",
      "IBM",
      "AXP",
      "PSX",
      "PG",
      "WMT",
      "USB",
      "DVA",
      "MCO",
      "T",
      "GS",
      "CHTR",
      "GM",
      "DE",
      "USG",
      "PCP",
      "VRSN",
      "SU",
      "BK",
      "V",
      "MTB",
      "VZ",
      "COST",
      "AXTA",
      "LMCK",
      "LBTYA",
      "MA",
      "WBC"
    ]
    query.where(symbol: symbols)
  end
end