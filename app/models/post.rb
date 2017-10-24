class Post < ApplicationRecord
  include PgSearch
  pg_search_scope :search_full_text, against: {
      title: "A",
      description: "C"
  }

  belongs_to :user
  has_many :comments, dependent: :destroy

  scope :sort_by_created_at_desc, -> { order(created_at: :desc ) }
  scope :sort_by_created_at_asc, -> { order(:created_at ) }
end
