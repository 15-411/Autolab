class AddGradeLatestToAssessment < ActiveRecord::Migration
  def change
    add_column :assessments, :grade_latest, :boolean, default: true
  end
end
