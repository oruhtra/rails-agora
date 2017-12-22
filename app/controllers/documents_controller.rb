class DocumentsController < ApplicationController
  before_action :set_user
  before_action :set_document, only: [:show, :edit, :update, :destroy]

  def index
    @user_selected_tags = []
    @tag_class_verified = policy_scope(Tag)

    # get selected tags and get all unselected documents tagged from query
    if params[:query].present?
      @user_selected_tags = @tag_class_verified.tag_from_tagnames(params[:query].downcase.split(" "))
    end

    # get search tag and add it to the selected tags
    if !params[:search_tag].nil?
      search_tag_array = @tag_class_verified.tag_from_tagnames(params[:search_tag].join.downcase.split(" "))
      search_tag_array.each do |t|
        @user_selected_tags << t unless t.nil? || @user_selected_tags.include?(t)
      end
    end

    #remove all nil in the @userselectedtags
    @user_selected_tags.compact!

    # get all tagged document based on selected tags (unselected)
    @documents_unselected = policy_scope(Document).user_documents_tagged(@user_selected_tags).select{|d| d.selected == false}
    # sort them by date updates_at, last on the top
    @documents_unselected.sort_by!{ |doc| doc.id }.reverse!

    # get remaining tags
    @user_tags = @tag_class_verified.remaining_tags(@user_selected_tags).sort_by!{ |t| t.occurrence}.reverse
    @user_tags_alphabetic =  @tag_class_verified.remaining_tags(@user_selected_tags).sort_by!{ |t| t.name_clean}

    #get selected tags names array (for the view => the search bar hidden field needs it to keep track of the query params)

    if !@user_selected_tags.empty?
      @user_selected_tagnames = @tag_class_verified.tagnames_from_tags(@user_selected_tags).join(" ")
    else
      @user_tags = @user_tags.select!{ |t| t.category == "macro_category" }
    end

    # select tags true for all remaining documents (OUT FOR NOW)
    # true_for_all_tags = @user_tags.select{ |t| t.occurrence == @documents_unselected.length}
    # @user_tags.reject!{ |t| t.occurrence == @documents_unselected.length}
    # @user_selected_tags = @user_selected_tags + true_for_all_tags

    # get selected documents (to display on the right)
    @documents_selected = policy_scope(Document).where(selected: true)

    @document = Document.new

    # respond with js when a tag is clicked

    respond_to do |format|
      format.html { render 'index' }
      format.js
    end


    # GET NUMBERS OF DOCS SINCE LAST CONNECTION
    # @lastconnexion = (Time.now() - (600*1))
    # @numnewdoc = (@documents_unselected + @documents_selected).count {|doc| doc.updated_at > @lastconnexion }
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
    @other_tags = policy_scope(Tag).all.sort_by{ |t| t.name }
    @tag = Tag.new
  end

  def create #documents are saved as soon as they are put in the dropzone without tags
    @document = Document.new(document_params)
    @document.user = @user
    authorize @document
    @document.photo = params[:file]
    @document.name = correctDocumentName(params["file"].original_filename)
    if @document.save
      @document = Document.find(@document.id)
      @document.update(ratio: @document.get_image_ratio)
      respond_to do |format|
        format.html { render }
        format.json do
          document_hash = {id: @document.id}
          render json: document_hash
        end
      end
    else
      render :new
    end
  end

  def add_tags
    @documents = current_user.documents.where(id: params[:document_ids]).order(:id)
    @tags = policy_scope(Tag).all
    @tag = Tag.new
    authorize @documents.first
  end


  def batch_update #adding tags to all documents of the dropzone
    @documents_all = current_user.documents.where(id: params[:documents_all_ids]).order(:id)
    if params[:document_to_tag_ids].present? && params[:tag].present?
      @documents = current_user.documents.where(id: params[:document_to_tag_ids])
      tag_name = params[:tag][:name].downcase.gsub(/\s/, "_")
      @tag = get_tag(tag_name)
      @documents.each do |d|
        create_doctag(d, @tag)
      end

    elsif params[:document_to_tag_ids].present? && params[:tagname].present?
      @documents = current_user.documents.where(id: params[:document_to_tag_ids])
      tagname = params[:tagname]
      tag = Tag.tag_from_tagnames([tagname])[0]
      @documents.each do |d|
        create_doctag(d, tag)
      end
    end

    authorize @documents.first

    respond_to do |format|
      format.js
      format.html { redirect_back(fallback_location: root_path) }
    end
  end

  # def batch_create_tag
  #   @documents = current_user.documents.where(id: params[:document_ids])
  #   if documents.any?
  #     @tag = Tag.new

  #     authorize documents.first

  #     @tag_name = params[:tag][:name].downcase.gsub(/\s/, "_")

  #     if Tag.tag_from_tagnames([@tag_name]).first.nil?
  #       @tag.name = @tag_name
  #       @tag.category = "user_specific"
  #       @tag.save
  #     else
  #       @tag = Tag.tag_from_tagnames([@tag_name]).first
  #     end

  #     @documents.each do |d|
  #       create_doctag(d, @tag)
  #     end
  #   else
  #     document = Document.new
  #     document.user = current_user
  #     authorize document
  #   end

  #   respond_to do |format|
  #     format.html { redirect_back(fallback_location: root_path) }
  #     format.js
  #   end
  # end

  def update
    authorize @document

    @document.update(document_params)
    redirect_back(fallback_location: root_path)
  end

  def destroy
    authorize @document

    @document.destroy
    redirect_to documents_path
  end

  def download
    @document = Document.find(params[:id])
    authorize @document

    file = open(@document.photo.url)
    send_file(file, :filename => "#{@document.name}")
  end

  def unselect_docs
    @documents_selected = policy_scope(Document).user_documents_selected
    @documents_selected.update(selected: false)
    redirect_to documents_path
  end

  def downloadzip
    @documents_selected = policy_scope(Document).user_documents_selected
    docs_public_ids = @documents_selected.map { |doc| doc.photo.file.public_id }
    url = Cloudinary::Utils.download_zip_url(
    :public_ids => docs_public_ids,
    :use_original_filename => true,
    :resource_type => 'image')
    zip = open(url)
    send_file(zip, :filename => "Agora_#{Time.now.strftime("%Y%e%m_%l%M")}.zip" )
  end


  def scrap_documents
    @document = Document.new
    @document.user = current_user
    authorize @document
    ScrapJob.perform_later(current_user.id)
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

  def get_tag(tag_name)
    tag = Tag.new
    if Tag.tag_from_tagnames([tag_name]).first.nil?
      tag.name = tag_name
      tag.category = "user_specific"
      tag.save
    else
      tag = Tag.tag_from_tagnames([tag_name]).first
    end
    return tag
  end

  def create_doctag(document, tag)
    unless document.tags.include?(tag)
      doctag = Doctag.new
      doctag.document = document
      doctag.tag = tag
      doctag.save
    end
  end

end
