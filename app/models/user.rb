class User < ActiveRecord::Base
  has_many :queue_items, -> { order(position: :asc) }

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  validates :full_name, presence: true

  has_secure_password validations: false

  def normalize_queue_item_positions!
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index + 1)
    end
  end
end