class ProcessEmailJob < ApplicationJob
  queue_as :default

  def perform(user, email)
    process_email_job(user, email)
  end

  def process_email_job(user, email)
    # create tags instance array
    tags = []
    # get email sender
    sender = email.body.match(/<.*@(.*)\..*>/)[1]
    # check if sender matches a tag and add the matches to tags
    tags += Tag.tag_from_match_in_name(sender)
    # check if any words in the subject matche a tag and add the matches to tags
    tags += Tag.tag_from_match_in_name(email.subject)
    # check if any words in the body matche a tag and add the matches to tags
    tags += Tag.tag_from_match_in_name(email.body)
    # for each attachment create a new document and upload it to CL
    email.attachments.each do |d|
      document = Document.new
      # upload file to cloudinary and store cloudinary response
      begin
        cl_response = Cloudinary::Uploader.upload(d.tempfile)
      rescue
        cl_response = nil
      end
      # if reponse then persist the document with the information from cloudinary
      if cl_response
        begin
          document.remote_photo_url = cl_response["secure_url"]
          document.name = d.original_filename
          document.user_id = user.id
          document.source = "email_scrapped"
          #delete first file from cloudinary, doing remote_photo_url duplicates the file so the first one needs to be destroyed
          Cloudinary::Uploader.destroy(cl_response["public_id"])
          # if document is saved add ratio to it and add tags
          if document.save
            document = Document.find(document.id)
            document.update(ratio: document.get_image_ratio)
            # add all tags from sender email and subject
            tags.each do |t|
              document.check_and_add_tag_to_document(t.name)
            end
            # check if document name contains a tag and add it if it does
            document.check_and_add_tag_to_document(document.name)
          end
        end
      end
    end
  end

end
