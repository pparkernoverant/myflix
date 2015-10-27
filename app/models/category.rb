class Category < ActiveRecord::Base
  include Sluggable

  has_and_belongs_to_many :videos

  sluggable_column :name
end