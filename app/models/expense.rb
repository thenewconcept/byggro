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

  default_scope { order(spent_on: :desc) }

  def self.search(filters)
    scope = all

    from = filters[:from] ? Time.zone.parse(filters[:from]) : Time.zone.now.beginning_of_month
    to   = filters[:to] ? Time.zone.parse(filters[:to]) : Time.zone.now.end_of_month
    by   = filters[:by] if filters[:by]

    scope = scope.where(spent_on: from..to)
    scope = scope.where(user_id: by) if by.present?
    scope
  end
end