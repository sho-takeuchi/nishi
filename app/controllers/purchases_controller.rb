class PurchasesController < ApplicationController
  before_action :move_to_signed_in

  def plan #定期課金プラン
    Payjp::Plan.create(
      :amount => 1000,
      :interval => 'month',
      :billing_day => 27,
      :currency => 'jpy',
    )
  end

  def index
    card = Card.where(user_id: current_user.id).first
    #テーブルからpayjpの顧客IDを検索
    if card.blank?
      #登録された情報がない場合にカード登録画面に移動
      redirect_to controller: "cards", action: "new"
    else
      Payjp.api_key = Rails.application.credentials.payjp[:PAYJP_PRIVATE_KEY]
      #保管した顧客IDでpayjpから情報取得
      customer = Payjp::Customer.retrieve(card.customer_id)
      #保管したカードIDでpayjpから情報取得、カード情報表示のためインスタンス変数に代入
      @default_card_information = customer.cards.retrieve(card.card_id)
    end
  end

  def pay
    card = Card.where(user_id: current_user.id).first
    Payjp.api_key = Rails.application.credentials.payjp[:PAYJP_PRIVATE_KEY]
    subscription = Payjp::Subscription.create(
    :customer => card.customer_id, 
    :plan => plan,
    metadata: {user_id: current_user.id}
    )
    current_user.update(subscription_id: subscription.id, premium: true)
    redirect_to action: 'done'
  end

  def cancel
    Payjp.api_key = Rails.application.credentials.payjp[:PAYJP_PRIVATE_KEY]
    subscription = Payjp::Subscription.retrieve(current_user.subscription_id)
    subscription.cancel
    current_user.update(premium: false)
    redirect_to action: 'canceled' 
  end

  private
  def move_to_signed_in
    unless user_signed_in?
      #サインインしていないユーザーはログインページが表示される
      redirect_to  '/users/sign_in'
    end
  end

end
