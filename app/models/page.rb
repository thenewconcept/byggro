class Page < ApplicationRecord
  has_rich_text :content
  scope :by_role, -> (role) { where("'#{role}' = ANY (access)") }
end
