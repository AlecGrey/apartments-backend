class NeighborhoodSerializer
  include JSONAPI::Serializer
  attributes :name
  has_many :apartments
end
