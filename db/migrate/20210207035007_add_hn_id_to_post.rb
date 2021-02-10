class AddHnIdToPost < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :hn_id, :bigint
  end
end
