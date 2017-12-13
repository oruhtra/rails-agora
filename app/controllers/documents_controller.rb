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

    # get remaining tags
    @user_tags = @tag_class_verified.remaining_tags(@user_selected_tags).sort_by!{ |t| t.occurrence}.reverse
    @user_tags_alphabetic =  @tag_class_verified.remaining_tags(@user_selected_tags).sort_by!{ |t| t.name_clean}

    #get selected tags names array (for the view => the search bar hidden field needs it to keep track of the query params)

    if !@user_selected_tags.empty?
      @user_selected_tagnames = @tag_class_verified.tagnames_from_tags(@user_selected_tags).join(" ")
    end

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
    @other_tags = policy_scope(Tag).all.sort_by{ |t| t.name }
    @tag = Tag.new
  end

  def create #documents are save as soon as they are put in the dropzone without tags
    @document = Document.new(document_params)
    @document.user = @user
    authorize @document
    @document.photo = params[:file]
    @document.name = correctDocumentName(params["file"].original_filename)

    if @document.save
      respond_to do |format|
        format.html { redirect_to document_path(@document) }
        format.json do
          document_hash = {id: @document.id}
          render json: document_hash
        end
      end
    else
      render :new
    end
  end

  def batch_update #adding tags to all documents of the dropzone
    docs = current_user.documents.where(id: params[:document_ids])
    if docs.any?
      tagnames = params[:tag_names].split(" ")
      tags = Tag.where(name: tagnames)
      docs.each do |doc|
        tags.each do |mytag|
          doc.tags << mytag
        end
      end
      authorize docs.first
      redirect_to documents_path
    else
      @document = Document.new
      authorize @document
      @other_tags = policy_scope(Tag).all
      render :new
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
    send_file(zip, :filename => "Agora_#{Time.now.strftime("%Y%e%m_%l%M")}" )
  end

  def scrap_documents
    #build BUDGEA GET request to access list of all documents from the user
    url = "https://agora.biapi.pro/2.0/users/me/documents/"
    headers = { "Authorization": "Bearer #{current_user.budgea_token}" }
    budgea_response = JSON.parse(RestClient.get(url, headers))
    @document = Document.new
    authorize @document

    # Iterate over all user documents from his accounts
    budgea_response["documents"].each do |document|
      #check if documents has already been downloaded and if it has an image
      if !document["url"].nil? && Document.where(budgea_doc_id: document["id_file"]).empty?
        #download file directly in cloudinary
        cl_response = Cloudinary::Uploader.upload(document["url"], headers: {"Authorization": "Bearer: #{current_user.budgea_token}"})
        #create doc and pass attributes
        @document.remote_photo_url = cl_response["secure_url"]
        @document.name = document["name"] + " " + document["issuer"]
        @document.user_id = current_user.id
        @document.budgea_doc_id = document["id_file"]


        @document.save
        #delete first file from cloudinary, doing remote_photo_url duplicates the file so the first one needs to be destroyed
        Cloudinary::Uploader.destroy(cl_response["public_id"])

        # get document date to date format
        document_date = document["date"].to_date

        #add tags to the document
        check_and_add_tag_to_document(@document, document["name"])
        check_and_add_tag_to_document(@document, document["issuer"])
        check_and_add_tag_to_document(@document, document_date.strftime("%Y"))

      end
    end
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

  def check_and_add_tag_to_document(document, tag_name)
    @tag = Tag.new
    # get user query and replace " " by _
    @tag_name = tag_name.downcase.gsub(/\s/, "_")
    # check if tag already exist by searching by tag.name instead of tag.id, if it doesn't exist create it
    if Tag.tag_from_tagnames([@tag_name]).first.nil?
      @tag.name = @tag_name
      @tag.save
    else
      @tag = Tag.tag_from_tagnames([@tag_name]).first
    end
    # check if document doesn't already include the tag, if it doesn't create a new doctag
    if !document.tags.include?(@tag)
      @doctag = Doctag.new
      @doctag.document = document
      @doctag.tag = @tag
      @doctag.save
    end
  end

end
