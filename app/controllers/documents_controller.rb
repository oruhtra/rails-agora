class DocumentsController < ApplicationController
  before_action :set_user
  before_action :set_document, only: [:show, :edit, :update]

  def index
    @user_selected_tags = []

    # get selected tags and get all unselected documents tagged from query
    if params[:query].present?
      @user_selected_tags = Tag.tag_from_tagnames(params[:query].split(" "))
    end

    # get search tag and add it to the selected tags
    if !Tag.tag_from_tagnames([params[:search_tag]]).first.nil?
      @user_selected_tags += Tag.tag_from_tagnames([params[:search_tag]])
    end

    # get all tagged document based on selected tags (unselected)
    @documents_unselected = Document.user_documents_tagged(@user_selected_tags).select{|d| d.selected == false}

    # get remaining tags
    @user_tags = Tag.remaining_tags(@user_selected_tags).sort_by!{ |t| t.occurrence}.reverse

    #get selected tags names array (for the view => the search bar hidden field needs it to keep track of the query)
    @user_selected_tagnames = Tag.tagnames_from_tags(@user_selected_tags).join(" ")

    # select tags true for all remaining documents (OUT FOR NOW)
    # true_for_all_tags = @user_tags.select{ |t| t.occurrence == @documents_unselected.length}
    # @user_tags.reject!{ |t| t.occurrence == @documents_unselected.length}
    # @user_selected_tags = @user_selected_tags + true_for_all_tags

    # get selected documents (to display on the right)
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
    params.require(:document).permit(:name, :photo, :selected)
  end
end
