class AddPubcourseDataToCourse < ActiveRecord::Migration
  def self.up
    add_column :courses, :is_public_course, :bool, default: false
    add_column :courses, :course_type, :string, limit: 255
  end
  def self.down
    remove_column :courses, :is_public_course, :bool
    remove_column :courses, :course_type, :string
  end
end
