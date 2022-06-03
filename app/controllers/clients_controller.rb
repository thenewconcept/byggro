class ClientsController < ProtectedController
  def index
    authorize(:client)
    @clients = policy_scope(Client).all
  end

  def show
    @client = Client.find(params[:id])
    authorize @client
  end

  def new
    @client = Client.new
    @user = @client.build_user
    authorize @client
  end

  def create
    @client = Client.new(client_params)
    authorize @client

    @client.user.generate_password

    respond_to do |format|
      if @client.save
        format.html { redirect_to client_url(@client), notice: "Kunden har skapats" }
        format.json { render :show, status: :created, location: @client }
      else
        format.html { render :new, status: :unprocessable_entity, error: "Något saknas." }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @client = Client.find(params[:id])
    @user = @client.user
    authorize @client
  end


  private
  def client_params
    params
      .require(:client)
      .permit(
        :id, 
        :nid, 
        :company_name, 
        :street_adress, 
        :zipcode, 
        :city,
        user_attributes: [
          :first_name, 
          :last_name, 
          :avatar,
          :email, 
          :presentation,
          :phone,
          :password, 
          :password_confirmation,
        ],
      )
  end
end
