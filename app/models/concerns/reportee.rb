module Reportee
  extend ActiveSupport::Concern

  included do
    has_many :reports, as: :reportee, dependent: :destroy
  end
end