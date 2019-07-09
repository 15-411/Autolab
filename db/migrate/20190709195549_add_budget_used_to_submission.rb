class AddBudgetUsedToSubmission < ActiveRecord::Migration
  def change
    add_column :submissions, :budget_used, :integer, default: 0
  end
end
