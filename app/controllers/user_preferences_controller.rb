class UserPreferencesController < ApplicationController
  before_action :set_user, only: :create

  def create
    @user_preference = UserPreference.new
    @user_preference.user = @user
    authorize @user_preference

    @user_preference.update(user_preference_params)

    respond_to do |format|
      format.html  { redirect_back(fallback_location: root_path) }
      format.js
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_preference_params
    params.require(:user_preference).permit(:setting, :value)
  end
end
