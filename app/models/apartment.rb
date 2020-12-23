class Apartment < ApplicationRecord
  belongs_to :neighborhood, dependent: :destroy
  has_many :images
end
