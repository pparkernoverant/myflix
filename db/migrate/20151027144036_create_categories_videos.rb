class CreateCategoriesVideos < ActiveRecord::Migration
  def change
    create_table :categories_videos, id: false do |t|
      t.belongs_to :category, index: true
      t.belongs_to :video, index: true
    end
  end
end
