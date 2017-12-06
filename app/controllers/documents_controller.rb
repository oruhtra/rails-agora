class DocumentsController < ApplicationController
  before_action :set_user
  before_action :set_document, only: [:show, :edit, :update]

  def index
    # get selected tags and get all unselected documents tagged from query
    if params[:query].present?
      @user_selected_tags = Tag.tag_from_tagnames(params[:query].split(" "))
      @documents_unselected = Document.user_documents_tagged(@user_selected_tags).select{|d| d.selected == false}
    else
       @user_selected_tags = []
       @documents_unselected = Document.where(user_id: @user.id, selected: false)
    end

    # get remaining tags
    @user_tags = Tag.remaining_tags(@user_selected_tags).sort_by!{ |t| t.occurrence}.reverse

    # select tags true for all remaining documents
    # true_for_all_tags = @user_tags.select{ |t| t.occurrence == @documents_unselected.length}
    # @user_tags.reject!{ |t| t.occurrence == @documents_unselected.length}
    # @user_selected_tags = @user_selected_tags + true_for_all_tags
    # get selected documents
    @documents_selected = Document.where(user_id: @user.id, selected: true)
  end

  def show
    @doctags = @document.doctags
    @other_tags = @user.tags - @document.tags
  end

  def new
    @document = Document.new
  end

  def create
    @document = Document.new
    @document.user = @user
    @document.update(document_params)
    @document.name = correctDocumentName(params["document"]["photo"].original_filename)
    if @document.save
      redirect_to document_path(@document)
    else
      render :new
    end
  end

  def update
    @document.update(document_params)
    redirect_to document_path(@document)
  end


  private

  def set_user
    @user = current_user
  end

  def set_document
    @document = Document.find(params[:id])
  end

  def document_params
    params.require(:document).permit(:name, :photo, :selected)
  end

  def correctDocumentName(uploadedName)
    uploadedName.gsub("[^\\]*$", "")
  end
end
