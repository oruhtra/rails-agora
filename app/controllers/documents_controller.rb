class DocumentsController < ApplicationController
  before_action :set_user
  before_action :set_document, only: [:show, :edit, :update, :destroy]

  def index
    @user_selected_tags = []
    @tag_class_verified = policy_scope(Tag)

    # get selected tags and get all unselected documents tagged from query
    if params[:query].present?
      @user_selected_tags = @tag_class_verified.tag_from_tagnames(params[:query].split(" "))
    end

    # get search tag and add it to the selected tags
    if !params[:search_tag].nil?
      search_tag_array = @tag_class_verified.tag_from_tagnames(params[:search_tag].split(" "))
      search_tag_array.each do |t|
        @user_selected_tags << t unless t.nil? || @user_selected_tags.include?(t)
      end
    end

    # get all tagged document based on selected tags (unselected)
    @documents_unselected = policy_scope(Document).user_documents_tagged(@user_selected_tags).select{|d| d.selected == false}

    # get remaining tags
    @user_tags = @tag_class_verified.remaining_tags(@user_selected_tags).sort_by!{ |t| t.occurrence}.reverse

    #get selected tags names array (for the view => the search bar hidden field needs it to keep track of the query)
    @user_selected_tagnames = @tag_class_verified.tagnames_from_tags(@user_selected_tags).join(" ")

    # select tags true for all remaining documents (OUT FOR NOW)
    # true_for_all_tags = @user_tags.select{ |t| t.occurrence == @documents_unselected.length}
    # @user_tags.reject!{ |t| t.occurrence == @documents_unselected.length}
    # @user_selected_tags = @user_selected_tags + true_for_all_tags

    # get selected documents (to display on the right)
    @documents_selected = policy_scope(Document).where(selected: true)
  end

  def show
    authorize @document

    @doctags = @document.doctags
    @other_tags = policy_scope(Tag).all - @document.tags
    @tag = Tag.new
  end

  def new
    @document = Document.new

    authorize @document
  end

  def create
    @document = Document.new
    @document.user = @user

    authorize @document

    @document.update(document_params)
    @document.name = correctDocumentName(params["document"]["photo"].original_filename)
    if @document.save
      redirect_to document_path(@document)
    else
      render :new
    end
  end

  def update
    authorize @document

    @document.update(document_params)
    redirect_to document_path(@document)
  end

  def destroy
    authorize @document

    @document.destroy
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
    params.require(:document).permit(:name, :photo, :selected)
  end


  def correctDocumentName(uploadedName)
    uploadedName.gsub("[^\\]*$", "")
  end

end
