class Checklist < ApplicationRecord
  validates :title, presence: true
  has_many :todos, -> { order(position: :asc) }, dependent: :destroy 
  belongs_to :project
end
