class DocumentsController < ApplicationController
  before_action :set_user, :set_user_preferences
  before_action :set_document, only: [:show, :show_modal, :edit, :update, :destroy]

  def index
    # store the tag policy scope in a variable
    @user_tags = []
    @user_tags_alphabetic = []
    @tag_class_verified = policy_scope(Tag).all
    # get selected documents (to display on the right)
    @documents_selected = policy_scope(Document).where(selected: true)
    # get all tagged document based on selected tags (unselected), sorted by date updates_at, last on the top
    @documents_unselected = policy_scope(Document).where(selected: false).sort_by{ |doc| doc.id }.reverse!
    # check wether or not the user added any documents on it's own and pass it to the view for the modal first_tips
    if policy_scope(Document).where(prototype: false).empty?
      @any_user_docs = false
    else
      @any_user_docs = true
    end
    # get user prototypes document to easily delete them
    @user_prototypes = policy_scope(Document).where(prototype: true)
    # get all untagged_documents and pass it to the view to see wether or not it should display the 'add tags button in the navbar'
    @documents_untagged = policy_scope(Document).select{ |d| d.tags.empty? }
    # get all user tags
    @user_tags = @documents_unselected.map { |d| d.tags }.flatten.uniq
    # get the user Macro-category and User-specific tags of all user's document displayed on the page and order them by occurrence
    if !@user_tags.empty?
      @user_tags_alphabetic =  @user_tags.sort_by{ |t| t.name_clean}
      @user_tags.select!{ |t| t.category == "macro_category" || t.category == "user_specific" }.sort_by!{ |t| t.occurrence(@user)}.reverse!
    end
    # pass an array of tags sorted alphabetically to the search bar (used un select2)
    # pass in a new instance of document to the view for the dropzone
    @document = Document.new
  end

  def show
    authorize @document

    @doctags = @document.doctags
    @other_tags = policy_scope(Tag).all - @document.tags
    @tag = Tag.new

    @document_new = Document.new

    respond_to do |format|
      format.js
      format.html
    end
  end

  def create #documents are saved as soon as they are put in the dropzone without tags
    @document = Document.new(document_params)
    @document.user = @user
    authorize @document
    @document.photo = params[:file]
    @document.name = correctDocumentName(params["file"].original_filename)
    @document.source = "user_added"
    if @document.save
      @document = Document.find(@document.id)
      @document.update(ratio: @document.get_image_ratio)
      Tag.tag_from_match_in_name(@document.name).each do |t|
        @document.add_one_tag_to_document(t)
        t.macro_categories.each do |c|
          @document.add_one_tag_to_document(Tag.find_by(name: c.name))
        end
      end
      respond_to do |format|
        format.html  { redirect_back(fallback_location: root_path) }
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
    @tags = policy_scope(Tag)
    @tag = Tag.new
    authorize @documents.first
  end


  def batch_update #adding tags to all documents
    # getting all the documents displayed on the page => used in JS response
    @documents_all = current_user.documents.where(id: params[:documents_all_ids]).order(:id)

    authorize @documents_all.first

    # adding tags to the documents selected => first check if there are any documents selected and if the user didn't send an empty name array
    if params[:document_to_tag_ids].present?
      @documents = current_user.documents.where(id: params[:document_to_tag_ids])
      if params[:tag].present? && params[:tag][:name] != ''
        # Adding tag that was inputed by hand by the user => first check if it exist or not, if not create it and add the doctag
        tag_name = params[:tag][:name].downcase.gsub(/\s/, "_")
        # get the corresponding tag => if it doesn't exist create it
        tag = get_tag(tag_name)
        # create the doctags linking the documents and the tag
        @documents.each do |d|
          create_doctag(d, tag)
        end
      elsif params[:add_tagname].present?
        # Adding the tag on which the user clicked to the documents
        tag_name = params[:add_tagname]
        # get the corresponding tag => if it doesn't exist create it
        tag = get_tag(tag_name)
        # create the doctags linking the documents and the tag
        @documents.each do |d|
          create_doctag(d, tag)
        end
      end
    end

    # respond with JS => send code to replace the documents 'hover' sections to display the tags that were added
    respond_to do |format|
      format.js
      format.html { redirect_back(fallback_location: root_path) }
    end
  end


  def delete_batch #adding tags to all documents
    # getting all the documents displayed on the page => used in JS response
    @documents_all = current_user.documents.where(id: params[:documents_all_ids]).order(:id)

    authorize @documents_all.first

    # adding tags to the documents selected => first check if there are any documents selected and if the user didn't send an empty name array
    if params[:document_to_tag_ids].present?
      @documents = current_user.documents.where(id: params[:document_to_tag_ids])
      if params[:delete_tagname].present?
        # Adding the tag on which the user clicked to the documents
        tag_name = params[:delete_tagname]
        # get the corresponding tag => if it doesn't exist create it
        tag = get_tag(tag_name)
        # create the doctags linking the documents and the tag
        @documents.each do |d|
          destroy_doctag(d, tag)
        end
      end
    end

    # respond with JS => send code to replace the documents 'hover' sections to display the tags that were added
    respond_to do |format|
      format.js
      format.html { redirect_back(fallback_location: root_path) }
    end
  end

  def load_new_elements
    @documents_new = current_user.documents.where(id: params[:document_ids]).order(:id)
    @documents_unselected = policy_scope(Document).where(selected: false) - @documents_new

    authorize @documents_new.first

    respond_to do |format|
      format.js
      format.html { redirect_back(fallback_location: root_path) }
    end
  end

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

  def destroy_prototypes
    documents = policy_scope(Document).where(prototype: true)
    authorize documents.first
    documents.destroy_all
    redirect_to documents_path
  end

  def download
    @document = Document.find(params[:id])
    authorize @document

    file = open(@document.photo.url)
    format = @document.photo.file.format
    send_file(file, :filename => "#{@document.name}.#{format}")
  end

  def unselect_docs
    @documents_selected = policy_scope(Document).user_documents_selected(current_user)
    @documents_selected.update(selected: false)
    redirect_to documents_path
  end

  def downloadzip
    @documents_selected = policy_scope(Document).user_documents_selected(current_user)
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
    ScrapWorker.perform_async(current_user.id, 0)
    redirect_to documents_path
  end

  private

  def set_user
    @user = current_user
  end

  def set_document
    @document = Document.find(params[:id])
  end

  def set_user_preferences
    # Pass a user_preference instance to the view for the modal
    @user_preference = UserPreference.new
    # Pass all the current user preferences array to deceide whether or not to show the modals
    @user_preferences = [] + UserPreference.where(user_id: @user.id).map { |p| p.setting  }
  end

  def document_params
    params.require(:document).permit(:name, :photo, :selected)
  end


  def correctDocumentName(uploadedName)
    uploadedName.gsub("[^\\]*$", "")
  end

  def get_tag(tag_name)
    tag = Tag.new
    if tag_name == '' || tag_name.nil?
      return nil
    elsif Tag.tag_from_tagnames([tag_name]).first.nil?
      tag.name = tag_name
      tag.category = "user_specific"
      tag.user_id = current_user.id
      tag.save
    else
      tag = Tag.tag_from_tagnames([tag_name]).first
    end
    return tag
  end

  def create_doctag(document, tag)
    if !document.tags.include?(tag) && !tag.nil?
      doctag = Doctag.new
      doctag.document = document
      doctag.tag = tag
      doctag.source = "user_added"
      doctag.save
    end
  end

  def destroy_doctag(document, tag)
    if document.tags.include?(tag)
      doctag = Doctag.where(tag: tag, document: document).first
      doctag.destroy
    end
  end

end
