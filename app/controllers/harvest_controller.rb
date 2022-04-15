class HarvestController < ProtectedController
  def index
    @client = Harvesting::Client.new(
      account_id: Rails.application.credentials.harvest.account_id,
      access_token: Rails.application.credentials.harvest.access_token
    )
  end
end
