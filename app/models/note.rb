class Note < ApplicationRecord
  belongs_to :user
  belongs_to :project

  validates :user, associated: true

  default_scope { order(created_at: :desc) }
end
