class Store < ActiveRecord::Base
  has_one :amazon, dependent: :destroy
  has_many :speeds, dependent: :destroy
  has_many :zones, dependent: :destroy
  has_many :orders, dependent: :destroy
  validates :owner_id, uniqueness: true
end
