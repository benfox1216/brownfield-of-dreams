class ConfirmationController < ApplicationController
  def show
    session[:user_id] = confirmation_params[:user_id]
  end

  def update
    flash[:success] = 'Status: Active'
    redirect_to '/dashboard'
  end

  private

  def confirmation_params
    params.permit(:user_id)
  end
end
