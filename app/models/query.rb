class Query < ApplicationRecord
  belongs_to :site
  has_many :ranks

  validates :keyword, presence: true, uniqueness: { scope: :url }
  validates :url, presence: true

  scope :for_search_type_zero, -> { where(search_type: 0) }
  scope :for_search_type_one, -> { where(search_type: 1) }
end