class Expense < ApplicationRecord
  CATEGORIES = [
    ['Materialinköp', 'material'],
    ['Bilkostnad', 'car'],
    ['Övrigt', 'other']
  ]

  belongs_to :user
  belongs_to :project

  validates_associated :user
  validates_presence_of :category, :amount, :spent_on
end