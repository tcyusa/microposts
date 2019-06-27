class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show, :edit]
  def index
    @users = User.order(id: :desc).page(params[:page]).per(25)
  end

  def show
    set_user
    @microposts = @user.microposts.order(id: :desc).page(params[:page])
    counts(@user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end
  
  def edit
    set_user
  end
  
  def update
    set_user
    
    if @user.update(user_params)
      flash[:success] = 'プロフィールを編集しました。'
      redirect_to @user
    else
      flash.now[:danger] = 'プロフィールの編集に失敗しました。'
      render :edit
    end
  end
  
  private
  
  def set_user
    @user = User.find(params[:id])
  end
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
