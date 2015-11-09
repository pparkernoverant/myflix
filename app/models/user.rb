class User < ActiveRecord::Base
  has_many :queue_items

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  validates :full_name, presence: true

  has_secure_password validations: false
end