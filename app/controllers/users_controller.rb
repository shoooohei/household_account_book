class UsersController < ApplicationController
  skip_before_action :check_logging_in, only: [:new, :create]
  skip_before_action :check_partner, only: [:new, :create, :show, :register_partner]
  before_action :set_user, only: [:show, :register_partner]
  include UsersHelper

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to user_path(@user)
    else
      render 'new'
    end
  end

  def show
  end

  def register_partner
    if @partner = User.find_by(email: params[:user][:partner_email])
      @user.assign_attributes(partner_id: @partner.id)
      @user.save(validate: false)
      @partner.assign_attributes(partner_id: @user.id)
      @partner.save(validate: false)
      redirect_to root_path, notice: "#{@partner.name}さんをパートナーとして登録しました。"
    else
      @user.errors[:base] << 'パートナーが登録されていません。'
      render 'show'
    end
  end


  def edit
  end

  private
   def user_params
     params.require(:user).permit(:name, :email, :password, :password_confirmation)
   end

  def set_user
    @user = User.find(params[:id])
  end
end
