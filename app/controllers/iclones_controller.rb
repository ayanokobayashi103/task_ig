class IclonesController < ApplicationController
  before_action :authenticate_user, only: [:edit, :show, :update, :destroy, :new]
  before_action :set_iclone, only: [:edit, :show, :update, :destroy]

  def index
    @iclones = Iclone.all
  end

  def new
    @iclone = Iclone.new
  end

  def create
    @iclone = Iclone.new(iclone_params)
    @iclone.user_id = current_user.id
    if params[:back]
      render :new
    else
      if @iclone.save
        ContactMailer.contact_mail(@iclone).deliver
        redirect_to iclones_path, notice:"#{current_user.name}さんが新規作成しました！"
      else
        render :new
      end
    end
  end

  def show
    @favorite = current_user.favorites.find_by(iclone_id: @iclone.id)
  end

  def edit
    unless @iclone.user_id == current_user.id
      redirect_to iclones_path, notice:"編集できません"
    end
  end

  def update
    if @iclone.update(iclone_params)
      redirect_to iclones_path, notice:"更新しました！"
    else
      render :edit
    end
  end

  def destroy
    unless @iclone.user_id == current_user.id
      redirect_to iclones_path, notice:"削除できません"
    else
      redirect_to iclones_path, notice:"削除しました！"
      @iclone.destroy
    end
  end

  def confirm
    @iclone = current_user.iclones.build(iclone_params)
    render :new if @iclone.invalid?
  end

  private
  def iclone_params
    params.require(:iclone).permit(:image, :content, :image_cache)
  end

  def set_iclone
    @iclone = Iclone.find(params[:id])
  end

  def authenticate_user
    unless logged_in?
      redirect_to iclones_path, notice:"ログインしてください！"
    end
  end
end
