class Todo < ApplicationRecord
  validates :description, presence: true
  belongs_to :checklist
  acts_as_list scope: :checklist
  delegate :project, to: :checklist
end
