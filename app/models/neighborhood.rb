class Neighborhood < ApplicationRecord
    has_many :apartments, dependent: :destroy
end
