class Speed < ActiveRecord::Base
  belongs_to :store
  validates_uniqueness_of :id, scope: [:shop_id, :shipping_speed]
end