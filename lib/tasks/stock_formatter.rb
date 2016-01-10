module StockFormatter
  class << self
    # Given the following value returns a float value
    #
    #   Params:
    #     value_string: (4,000.00)
    #
    #   Returns:
    #     float: -4000.00
    #
    def to_float(value_string)
      return_float = 0
      if !value_string.nil? && value_string != "N/A" && value_string !="-"
        if value_string.include?("(") && value_string.include?(")") 
          value_string = value_string.delete("(").delete(")")
          value_string = "-" + value_string
        end

        return_float = value_string.delete(",").to_f 
      end
      return_float
    end

    # Given the raw total_equity value, total asset and total_liability values
    # returns the proper equity
    def to_equity(raw_total_eq, total_ass, total_lia)
      return_float = to_float(raw_total_eq)
      return_float = total_ass - total_lia if return_float == 0
      return_float
    end

    # Given the following value returns a float value
    #
    #   Params:
    #     value_string: 327.66M
    #
    #   Returns:
    #     float: 327660000
    #    
    def to_non_shorthand(value_string)
      return_float = 0
      if !value_string.nil? && value_string != "N/A"
        if value_string.include?("B")
          return_float = value_string.delete("B").to_f * 1000000000
        elsif value_string.include?("M")
          return_float = value_string.delete("M").to_f * 1000000
        elsif value_string.include?("K")
          return_float = value_string.delete("K").to_f * 1000000
        end
      end
      return_float
    end

    # Removes the breakline in a string unless its nil
    # If string is NIl returns empty string
    def to_string(raw_string)
      processed_string = ''
      processed_string = raw_string.sub("\n", " ") unless raw_string.nil?
    end

    def to_ratio(origin_ratio, numerator, denominator)
      origin_ratio = numerator / denominator if origin_ratio == 0
      origin_ratio
    end

    def is_recent_year?(raw_string)
      return false if raw_string.nil?
      begin
         the_date = Date.parse raw_string
         years_difference = Time.now.year - the_date.year
         years_difference == 1 || years_difference == 0
      rescue ArgumentError
         false
      end      
    end
  end
end