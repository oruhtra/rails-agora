class ScrapJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    scrap_documents(user)
  end


  private

  def scrap_documents(user)
    puts "build BUDGEA GET request to access list of all documents from the user"

    url = "https://agora.biapi.pro/2.0/users/me/documents/"
    headers = { "Authorization": "Bearer #{user.budgea_token}" }
    budgea_response = JSON.parse(RestClient.get(url, headers))

    p budgea_response

    budgea_doc_id_array = Document.where(user_id: user.id).map{ |d| d.budgea_doc_id}.uniq!

    if budgea_doc_id_array.nil?
      budgea_doc_id_array = []
    end

    puts budgea_doc_id_array

    puts "Iterate over all user documents from his accounts"

    budgea_response["documents"].each do |d|
      #check if documents has already been downloaded and if it has an image
      if !d["url"].nil?
        if !budgea_doc_id_array.include?(d["id_file"])
          begin
            #download file directly in cloudinary
            puts "getting CL response"
            cl_response = Cloudinary::Uploader.upload(d["url"], headers: {"Authorization": "Bearer: #{user.budgea_token}"})

            #create doc and pass attributes
            document = Document.new
            puts "getting elements from CL response"
            document.remote_photo_url = cl_response["secure_url"]
            document.name = d["name"] + " " + d["issuer"]
            document.user_id = user.id
            document.budgea_doc_id = d["id_file"]
            document.source = "supplier_scrapped"

            puts "saving document"
            document.save
            #delete first file from cloudinary, doing remote_photo_url duplicates the file so the first one needs to be destroyed
            Cloudinary::Uploader.destroy(cl_response["public_id"])

            document = Document.find(document.id)
            document.update(ratio: document.get_image_ratio)

            puts "adding date"
            puts "°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°"

            # get document date to date format
            if !d["date"].nil?
              document_date = d["date"].to_date
              puts document_date
              check_and_add_tag_to_document(document, document_date.strftime("%b %Y"), "date")
            end

            puts "adding supplier"
            puts "°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°"

            # get document service
            supplier = Service.where(budgea_name: d["issuer"].downcase).first
            puts supplier
            if !supplier.nil?
              check_and_add_tag_to_document(document, supplier.macro_category, "macro_category")
              check_and_add_tag_to_document(document, supplier.name, "supplier")
            end

            puts "adding doc_type"
            puts "°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°"

            check_and_add_tag_to_document(document, d["name"], "doc_type")

            puts "DOC ADDED"
            puts "================================"
          rescue
            puts "exception encoutered"
          end
        end
      end
    end
  end

  def check_and_add_tag_to_document(document, tag_name, tag_category)
    puts "adding one tag"
    tag = Tag.new
    # get tag_name and replace " " by _ and downcase
    tag_name = tag_name.downcase.gsub(/\s/, "_")
    puts "searching if tag exist"
    # check if tag already exist by searching by tag.name instead of tag.id, if it doesn't exist create it
    if Tag.tag_from_tagnames([tag_name]).first.nil?
      tag.name = tag_name
      tag.category = tag_category
      tag.save
    else
      tag = Tag.tag_from_tagnames([tag_name]).first
    end
    # check if document doesn't already include the tag, if it doesn't create a new doctag
    if !document.tags.include?(tag)
      doctag = Doctag.new
      doctag.document = document
      doctag.tag = tag
      doctag.save
    end
  end

end
