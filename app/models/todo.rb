class Todo < ApplicationRecord
  validates :description, presence: true
  belongs_to :checklist
  delegate :project, to: :checklist
end
