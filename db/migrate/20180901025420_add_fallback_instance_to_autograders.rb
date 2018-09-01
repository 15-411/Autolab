class AddFallbackInstanceToAutograders < ActiveRecord::Migration
  def change
    add_column :autograders, :autograde_fallback_instance_type, :string, limit: 255, default: ''
  end
end
