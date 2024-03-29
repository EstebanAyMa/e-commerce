class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Por favor, revise su correo electronico para activar cuenta."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Perfil ha sido actualizado."
      redirect_to edit_user_path @user
    else
      render 'edit'
    end
  end

  private

  def user_params
     params.require(:user).permit(:first_name, :last_name, :email,
                                  :password, :password_confirmation)
  end

  def correct_user
    user = User.find(params[:id])
    redirect_to root_url unless current_user?(user)
  end
end
