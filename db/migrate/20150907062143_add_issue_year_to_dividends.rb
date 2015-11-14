class AddIssueYearToDividends < ActiveRecord::Migration
  def change
    add_column :dividends, :issue_year, :integer
  end
end
