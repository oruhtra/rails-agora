class DocumentsController < ApplicationController
  before_action :set_user
  before_action :set_document, only: [:show, :edit, :update]

  def index
    @documents = Document.where(user_id: @user.id)
  end

  def show
  end

  def new
    @document = Document.new
  end

  def create
    @document = Document.new
    @document.user = @user
    @document.save
    @document.update(document_params)
    redirect_to edit_document_path(@document)
  end

  def edit
  end

  def update
    @document.update(document_params)
    redirect_to documents_path
  end

  private

  def set_user
    @user = current_user
  end

  def set_document
    @document = Document.find(params[:id])
  end

  def document_params
    params.require(:document).permit(:name, :url)
  end
end
