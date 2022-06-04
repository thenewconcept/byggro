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

  def update
    @client = Client.find(params[:id])
    authorize(@client)
    if @client.update(client_params)
      redirect_to edit_user_url(@client), notice: 'Kund uppdaterad'
    else
      flash.now[:alert] = "Uppgifterna kunde inte uppdateras."
      render :edit, status: :unprocessable_entity
    end
  end


  private
  def client_params
    params
      .require(:client)
      .permit(
        :nid, 
        :company_name, 
        :street_adress, 
        :zipcode, 
        :city,
        user_attributes: [
          :id,
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
