class TopController < ApplicationController
  
  before_action :move_to_signed_in, except: [:index]
  
  def index
    if User.exists?
      if user_signed_in?
          @user = User.where(id: current_user.id).first
      end
    end
  end

  def mypage
    @email_addres = current_user.email
    @user = User.where(id: current_user.id).first
    @card = Card.where(user_id: current_user.id).first
    Payjp.api_key = Rails.application.credentials.payjp[:PAYJP_PRIVATE_KEY]

    if !@card.nil?
      customer = Payjp::Customer.retrieve(@card.customer_id)
      @default_card_information = customer.cards.retrieve(@card.card_id)
    end

  end

  def cancel
    Payjp.api_key = Rails.application.credentials.payjp[:PAYJP_PRIVATE_KEY]
    subscription = Payjp::Subscription.retrieve(current_user.subscription_id)
    subscription.cancel
    current_user.update(premium: false)
    redirect_to "/"
  end

  private
  def move_to_signed_in
    unless user_signed_in?
      #サインインしていないユーザーはログインページが表示される
      flash[:notice] = 'サービスの利用には会員登録が必要です。'
      redirect_to  '/users/sign_in'
    end
  end

end
