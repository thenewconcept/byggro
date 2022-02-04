# frozen_string_literal: true

Heroicon.configure do |config|
  config.variant = :solid # Options are :solid and :outline
  config.default_class = {solid: "h-5 w-5 inline", outline: "h-6 w-6"}
end
