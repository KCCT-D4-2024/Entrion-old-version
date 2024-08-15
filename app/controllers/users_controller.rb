require 'rqrcode'

class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users

  def enter
    @user = User.new(status: :entered, credit: 3)
    if @user.save
      redirect_to user_path(@user), notice: "User was successfully entered."
    else
      render root_path, status: :unprocessable_entity
    end
  end

  def exit
    @user = User.find(params[:id])

    qr = RQRCode::QRCode.new(user_process_exit_path(@user), size: 8, level: :h)
    @svg = qr.as_svg(offset: 0, color: '000', shape_rendering: 'crispEdges', module_size: 6, standalone: true)
  end

  def process_exit
    @user = User.find(params[:id])
    if @user.update(status: :exited, credit: 0)
      redirect_to users_path, notice: "User was successfully exited."
    else
      render root_path, status: :unprocessable_entity
    end
  end

  def index
    @users = User.all
  end

  # GET /users/1
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to @user, notice: "User was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      redirect_to @user, notice: "User was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy!
    redirect_to users_url, notice: "User was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:credit, :status)
    end
end
