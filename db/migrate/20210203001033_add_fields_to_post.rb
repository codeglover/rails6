class AddFieldsToPost < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :happy, :boolean
    add_column :posts, :scale, :integer
  end
end
