class ScrapJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    scrap_documents(user)
  end


  private

  def scrap_documents(user)
    #build BUDGEA GET request to access list of all documents from the user
    url = "https://agora.biapi.pro/2.0/users/me/documents/"
    headers = { "Authorization": "Bearer #{user.budgea_token}" }
    budgea_response = JSON.parse(RestClient.get(url, headers))

    # Iterate over all user documents from his accounts
    budgea_response["documents"].each do |document|
      #check if documents has already been downloaded and if it has an image
      if !document["url"].nil? && Document.where(budgea_doc_id: document["id_file"]).empty?
        #download file directly in cloudinary
        @document = Document.new

        cl_response = Cloudinary::Uploader.upload(document["url"], headers: {"Authorization": "Bearer: #{user.budgea_token}"})
        #create doc and pass attributes
        @document.remote_photo_url = cl_response["secure_url"]
        @document.name = document["name"] + " " + document["issuer"]
        @document.user_id = user.id
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
