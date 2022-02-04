class HomeController < ProtectedController
  def index
    @projects = Project.all
    #@client = Harvesting::Client.new( access_token: Rails.application.credentials.harvest.access_token, account_id: Rails.application.credentials.harvest.account_id)
  end
end
