class HarvestController < ApplicationController
  def index
    @client = Harvesting::Client.new(
      account_id: Rails.application.secrets.harvest.account_id,
      access_token: Rails.application.secrets.harvest.access_token
    )
  end
end