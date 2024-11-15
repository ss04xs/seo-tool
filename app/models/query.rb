class Query < ApplicationRecord
  belongs_to :site
  has_many :ranks

  validates :keyword, presence: true, uniqueness: { scope: :url }
  validates :url, presence: true
end