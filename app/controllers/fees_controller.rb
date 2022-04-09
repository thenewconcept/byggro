class FeesController < ProtectedController
  def index
    @fees = policy_scope(Fee).order(created_at: :desc)
    authorize(@fees)
  end
end