class Category < ActiveRecord::Base
  include Sluggable

  has_and_belongs_to_many :videos, -> { order(:title) }
  validates :name, presence: true

  sluggable_column :name

  def recent_videos
    ret_val = (videos.sort_by &:created_at).reverse[0...6]
  end
end