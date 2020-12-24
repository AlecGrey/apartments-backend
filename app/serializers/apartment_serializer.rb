class ApartmentSerializer
  include JSONAPI::Serializer
  attributes :price, :square_feet, :bedrooms, :bathrooms, :title, :description
  has_many :images
end
