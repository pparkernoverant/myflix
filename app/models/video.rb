class Video < ActiveRecord::Base
  include Sluggable

  has_and_belongs_to_many :categories

  sluggable_column :title
end