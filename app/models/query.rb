class Query < ApplicationRecord
  belongs_to :site
  has_many :ranks

  validates :keyword, presence: true, uniqueness: true
  validates :url, presence: true
end
