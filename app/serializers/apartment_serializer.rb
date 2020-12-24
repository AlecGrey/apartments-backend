class ApartmentSerializer
  include JSONAPI::Serializer
  attributes :price, :square_feet, :bedrooms, :bathrooms, :title, :description
  belongs_to :neighborhood
  has_many :images
end
