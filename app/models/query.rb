class Query < ApplicationRecord
  belongs_to :site
  has_many :ranks
end
