class DocumentsController < ApplicationController
  before_action :set_user
  before_action :set_document, only: [:show, :edit, :update]

  def index
    # get unselected documents containing a tag = query
    aquery = params[:query].split(" ") if params[:query].present?
    if params[:query].present?
      @documents_unselected = Document.where(user_id: @user.id, selected: false).select { |doc| !(aquery & doc.tagsname).nil? }
    else
      @documents_unselected = Document.where(user_id: @user.id, selected: false)
    end

    # get selected documents
    @documents_selected = Document.where(user_id: @user.id, selected: true)

    # get selected tags
    if params[:query].present?
      @user_selected_tags = params[:query].split(" ")
    else
       @user_selected_tags = []
    end
    @user_tags = @user.tagsname - @user_selected_tags
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

  def withtag
    params[:query].each do |tag|
      @documents_unselected.reject {|doc| doc.tags }


    end

    @documents_unselected
    @doDocument.where(user_id: @user.id, selected: false)
  end

end
