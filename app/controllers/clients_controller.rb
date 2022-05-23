class ClientsController < ProtectedController
  def index
    @clients = policy_scope(Client).all
  end
end
