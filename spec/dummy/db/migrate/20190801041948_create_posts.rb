class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.boolean :is_published, default: false, null: false

      t.timestamps
    end
  end
end
