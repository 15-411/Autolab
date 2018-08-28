class AddVmPropsToAutograders < ActiveRecord::Migration
  def change
    add_column :autograders, :autograde_cores, :integer, default: 1
    add_column :autograders, :autograde_memory, :integer, default: 1024
  end
end
