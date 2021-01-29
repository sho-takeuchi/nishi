class RecruitmentsController < ApplicationController
  before_action :move_to_signed_in
  before_action :move_to_card_registration

  def index
    
  end

  def show
    @recruitments = Recruitment.find(params[:id])
  end

  private
  def move_to_signed_in
    unless user_signed_in?
      #サインインしていないユーザーはログインページが表示される
      flash[:notice] = 'サービスの利用には会員登録が必要です。'
      redirect_to  '/users/sign_in'
    end
  end

  def move_to_card_registration
    #①サインインしてるが、カード情報がない場合
    card = Card.where(user_id: current_user.id).first
    if card.blank?
      flash[:notice] = 'サービスの利用にはカード登録と定期課金決済をお願いします。'
      redirect_to controller: "cards", action: "new"
      return
    end
    user = User.where(id: current_user.id).first
    unless user.premium?
      flash[:notice] = 'サービスの利用には定期課金決済が必要です。定期課金を再開してください。'
      redirect_to "/"
    end
  end


end
