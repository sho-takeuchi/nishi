class RecruitmentsController < ApplicationController
  before_action :move_to_signed_in
  
  def index
    
  end

private
  def move_to_signed_in
    unless user_signed_in?
      #サインインしていないユーザーはログインページが表示される
      redirect_to  '/users/sign_in'
    end
  end

  def show
    @recruitments = Recruitment.find(params[:id])
  end
end
