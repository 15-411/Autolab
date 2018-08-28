class AddInProgressToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :in_progress, :boolean, default: false
  end
end
