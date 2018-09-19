class Speed < ActiveRecord::Base
  belongs_to :store
  validates :shipping_speed, uniqueness: true
end