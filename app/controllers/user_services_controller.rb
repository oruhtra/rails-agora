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

    if params[:error_message].present?
      @error_message = params[:error_message]
    end

    respond_to do |format|
      format.html { render 'new' }
      format.js
    end

    authorize @user_service
  end

  def create
    @user_service = UserService.new
    @user = current_user
    authorize @user_service

    if params[:error_message].present?
      redirect_to new_user_service_path({:error_message => params[:error_message]})
    else
      @user_service.user_id = @user.id
      @user_service.service_id = params[:service_id]
      @user_service.connection_id = params[:id_connection]
      @user.budgea_token = get_permanent_token(params[:access_token])
      @user.save
      @user_service.save
      redirect_to documents_path
    end


  end

  private

  def get_permanent_token(auth_token)
    url = "https://agora.biapi.pro/2.0/auth/token/access"
    payload = { "client_id": ENV['BUDGEA_CLIENT_ID'], "client_secret": ENV['BUDGEA_CLIENT_SECRET'], "code": auth_token }
    headers = { "Content-Type": "application/json" }
    response = RestClient.post(url, payload, headers)
    return JSON.parse(response.body)["access_token"]
  end
end
