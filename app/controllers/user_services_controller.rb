class UserServicesController < ApplicationController
  before_action :set_user, :set_user_preferences

  def new
    @user_service = UserService.new
    @services = Service.all
    @services_user = current_user.services
    # create doc instance and pass user for the dropzone and 'add document' button
    @document = Document.new

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
    authorize @user_service

    if params[:error_message].present?

      if params[:error_message] == "wrongpass"
        flash[:alert] = "Echec - Mauvaise combinaison login / password"
      elsif params[:error_message] == "websiteUnavailable"
        flash[:alert] = "Echec - Site internet non disponible"
      elsif params[:error_message] == "actionNeeded"
        flash[:alert] = "Echec - Connexion impossible - une action est necessaire sur le site"
      else
        flash[:alert] = "Echec de la connexion"
      end

      redirect_to new_user_service_path

    else

      @user_service.user_id = @user.id
      @user_service.service_id = params[:service_id]
      @user_service.connection_id = params[:id_connection]

      if !@user.budgea_token
        @user.budgea_token = get_permanent_token(params[:access_token])
        @user.budgea_id = params[:id_user]
      end

      @user.save
      @user_service.save
      flash[:notice] = "Connexion réussie - vos documents sont en train d'être téléchargés"

      #launch the scrapp job sending in the user_service id
      ScrapWorker.perform_async(current_user.id, @user_service.id)

      redirect_to new_user_service_path

    end
  end

  def destroy
    @user_service = UserService.find(params[:id])
    authorize @user_service
    url = "https://agora.biapi.pro/2.0/users/#{current_user.budgea_id}/connections/#{@user_service.connection_id}"
    headers = { "Authorization": "Bearer #{current_user.budgea_token}" }

    RestClient.delete(url, headers)

    @user_service.destroy

    redirect_to new_user_service_path
  end

  private

  def set_user
    @user = current_user
  end

  def set_user_preferences
    # Pass a user_preference instance to the view for the modal
    @user_preference = UserPreference.new
    # Pass all the current user preferences array to deceide whether or not to show the modals
    @user_preferences = [] + UserPreference.where(user_id: @user.id).map { |p| p.setting  }
  end

  def get_permanent_token(auth_token)
    url = "https://agora.biapi.pro/2.0/auth/token/access"
    payload = { "client_id": ENV['BUDGEA_CLIENT_ID'], "client_secret": ENV['BUDGEA_CLIENT_SECRET'], "code": auth_token }
    headers = { "Content-Type": "application/json" }
    response = RestClient.post(url, payload, headers)
    return JSON.parse(response.body)["access_token"]
  end
end
