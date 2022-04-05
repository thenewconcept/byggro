class UsersController < ProtectedController
  before_action :set_user, only: %i[ show edit update destroy ]

  def index
    @users = policy_scope(User).all
  end

  # GET /projects/1 or /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @user = User.new
    authorize @user
  end

  # GET /projects/1/edit
  def edit
    authorize @user
  end

  # POST /projects or /projects.json
  def create
    @user = User.new(user_params)
    authorize @user

    respond_to do |format|
      if @user.save
        format.html { redirect_to project_url(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1 or /projects/1.json
  def update
    if @user.update(user_params)
      redirect_to edit_user_url(@user), notice: "Uppgifter uppdaterade."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /projects/1 or /projects/1.json
  def destroy
    authorize @user
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params
      .require(:user)
      .permit(
        :first_name, 
        :last_name, 
        :email, 
        :password, 
        :password_confirmation,
        employee_attributes: [ :id, :title, :salary ]
      )
  end
end