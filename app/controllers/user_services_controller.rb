class UserServicesController < ApplicationController
  def new
    @user_service = UserService.new
    @services = Service.all

    if params[:service_id].present? && Service.find(params[:service_id])
      @service = Service.find(params[:service_id])
    end

    if params[:provider_id].present?
      @provider = Service.where(budgea_id: params[:provider_id])
    end

    respond_to do |format|
      format.html { render 'new' }
      format.js
    end

    authorize @user_service
  end

  def create
  end

  private

  def user_service_params
    params.require(:user_service).permit(:service, :connection_id)
  end
end
