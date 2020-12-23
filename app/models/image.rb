class Image < ApplicationRecord
  belongs_to :apartment, dependent: :destroy
end
