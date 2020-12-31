class Apartment < ApplicationRecord
  belongs_to :neighborhood
  has_many :images, dependent: :destroy
end
