# frozen_string_literal: true

Heroicon.configure do |config|
  config.variant = :solid # Options are :solid and :outline
  config.default_class = {solid: "h-4 w-4 inline", outline: "h-4 w-4 inline"}
end
