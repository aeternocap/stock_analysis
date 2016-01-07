class StockImportJob < ActiveRecord::Base
  class << self
    def get_previous_job_id(curr_id)
      prev_job_id = where("id < ?", curr_id).order(id: :desc).limit(1).pluck(:id).first
    end

    def get_total_removed(curr_id)
      prev_id = self.get_previous_job_id curr_id
      if prev_id.present?
        query = "
          SELECT 
            COUNT(*) AS missing
          FROM stock_import_logs
          WHERE
            stock_import_job_id = #{prev_id} AND
            symbol NOT IN (
              SELECT
                symbol
              FROM stock_import_logs
              WHERE stock_import_job_id = #{curr_id}
            )
        "
        results = ActiveRecord::Base.connection.execute(query)
        if results.first.present?
          results.first.first
        else
          0
        end
      else
        0
      end

    end
  end

end