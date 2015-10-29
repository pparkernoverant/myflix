class Video < ActiveRecord::Base
  include Sluggable

  has_and_belongs_to_many :categories, -> { order(:name) }

  validates :title, presence: true
  validates :description, presence: true

  sluggable_column :title

  def self.search_by_title(search_term)
    ret_val = []
    ret_val = Video.where('LOWER(title) LIKE ?', "%#{search_term.downcase}%").order('created_at DESC') unless search_term.nil? || search_term.empty?
    return ret_val
  end

end