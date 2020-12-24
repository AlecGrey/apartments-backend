class ImageSerializer
  include JSONAPI::Serializer
  attributes :url
  belongs_to :apartment
end
