class Query < ApplicationRecord
  belongs_to :site
  has_many :ranks

  validates :keyword, presence: true, uniqueness: { scope: :site_id }
  validates :url, presence: true
end
