class Video < ActiveRecord::Base
  include Sluggable

  has_and_belongs_to_many :categories, -> { order(:name) }

  validates :title, presence: true
  validates :description, presence: true

  sluggable_column :title
end