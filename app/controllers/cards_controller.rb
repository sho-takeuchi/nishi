class CardsController < ApplicationController
  before_action :move_to_signed_in

  require 'payjp'

  before_action :set_api_key

  def plan #定期課金プラン
    Payjp::Plan.create(
      :amount => 1000,
      :interval => 'month',
      :billing_day => 27,
      :currency => 'jpy',
    )
  end

  def create #カード登録アクション
    if params['payjp-token'].blank?
      redirect_to action: "new"
      # トークンが取得出来てなければループ
    else
      user_id = current_user.id
      customer = Payjp::Customer.create(
      card: params['payjp-token']
      # params['payjp-token']（response.id）からcustomerを作成
      ) 
      @card = Card.new(user_id: user_id, customer_id: customer.id, card_id: customer.default_card)
      if @card.save
        pay #カード情報を保存できたらpayアクションを呼び出す。
      else
        flash[:alert] = '登録できませんでした'
        redirect_to action: "new"
      end
    end
  end

  def pay
    card = Card.where(user_id: current_user.id).first
    Payjp.api_key = Rails.application.credentials.payjp[:PAYJP_PRIVATE_KEY]
    subscription = Payjp::Subscription.create( #サブスク情報を作成して変数subscriptionに代入
    :customer => card.customer_id, 
    :plan => plan, #plamアクションで定義した情報を呼び出す
    metadata: {user_id: current_user.id}
    )
    current_user.update(subscription_id: subscription.id, premium: true)
    #subscription_idを持たせ、premiumカラムをtrueにして、user情報をアップデート
    flash[:alert] = '定期課金に登録できました'
    redirect_to "/"
  end

  def cancel
    Payjp.api_key = Rails.application.credentials.payjp[:PAYJP_PRIVATE_KEY]
    subscription = Payjp::Subscription.retrieve(current_user.subscription_id)
    subscription.cancel
    current_user.update(premium: false) #キャンセルしたユーザーは、premiumカラムをfalseにする
    flash[:alert] = '定期課金を解除できました'
    redirect_to "/" 
  end

  def set_api_key
    Payjp.api_key = Rails.application.credentials[:payjp][:PAYJP_PRIVATE_KEY]
  end
  
  private
  def move_to_signed_in
    unless user_signed_in?
      #サインインしていないユーザーはログインページが表示される
      redirect_to  '/users/sign_in'
    end
  end

end
