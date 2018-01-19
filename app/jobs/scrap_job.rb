class ScrapJob < ApplicationJob
  queue_as :default

  def perform(user_id, user_service_id = nil)
    user = User.find(user_id)
    if user_service_id.nil?
      # Scrap all user documents from all services
      user.user_services.each do |user_service|
        scrap_documents(user, user_service)
      end
    else
      # Scrap user documents from one service only
      user_service = UserService.find(user_service_id)
      sleep(30)
      scrap_documents(user, user_service)
    end
  end


  private

  def scrap_documents(user, user_service)
    supplier = user_service.service
    puts supplier

    puts "build BUDGEA GET request to access list of all documents from the user"


    url = "https://agora.biapi.pro/2.0/users/me/connections/#{user_service.connection_id}/documents/"
    headers = { "Authorization": "Bearer #{user.budgea_token}" }
    budgea_response = JSON.parse(RestClient.get(url, headers))

    puts "Iterate over all user documents from his accounts"

    budgea_response["documents"].each do |d|

      #check if documents has already been downloaded and if it has an image
      budgea_doc_id = d["number"].to_s
      doc = Document.where(budgea_doc_id: budgea_doc_id).first
      if !d["url"].nil?
        if !doc
          #download file directly in cloudinary
          puts "getting CL response"
          begin
            cl_response = Cloudinary::Uploader.upload(d["url"], headers: {"Authorization": "Bearer: #{user.budgea_token}"})
          rescue
            puts "could not download document"
            cl_response = nil
          end
          if cl_response
            #create doc and pass attributes
            document = Document.new
            puts "getting elements from CL response"
            document.remote_photo_url = cl_response["secure_url"]
            document.name = d["name"] + " " + d["issuer"]
            document.user_id = user.id
            document.budgea_doc_id = budgea_doc_id
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
              begin
                document_date = d["date"].to_date
                puts document_date
                check_and_add_tag_to_document(document, document_date, true)
              rescue
                puts "could not find date"
              end
            end

            puts "adding supplier"
            puts "°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°"

            # get document service
            if !supplier.nil?
              begin
                check_and_add_tag_to_document(document, supplier.macro_category.gsub(/_/, " "))
                check_and_add_tag_to_document(document, supplier.name_clean)
              rescue
                puts "could not find supplier"
              end
            end

            puts "adding doc_type"
            puts "°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°"

            begin
            check_and_add_tag_to_document(document, d["name"])
            rescue
              puts "could not find name"
            end

            puts "DOC ADDED"
            puts "================================"

          end
        end
      end
    end
  end

  def check_and_add_tag_to_document(document, tag_name, date_boolean = false)
    puts "adding one tag"
    if date_boolean
      puts "add a date"
      t = Tag.get_tag_from_date(tag_name)
      if t
        # check if document doesn't already include the tag, if it doesn't create a new doctag
        puts "creating date doctag"
        if !document.tags.include?(t)
          doctag = Doctag.new
          doctag.document = document
          doctag.tag = t
          doctag.save
        end
      end
    else
      puts "tags that match"
      tag_name.downcase!
      # searching all tags that match part of the name and creat
      if !Tag.tag_from_match_in_name(tag_name).first.nil?
        Tag.tag_from_match_in_name(tag_name).each do |t|
          # check if document doesn't already include the tag, if it doesn't create a new doctag
          puts "creating doctags"
          if !document.tags.include?(t)
            doctag = Doctag.new
            doctag.document = document
            doctag.tag = t
            doctag.save
          end
        end
      end
    end

  end

end
