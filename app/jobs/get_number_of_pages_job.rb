class GetNumberOfPagesJob < ApplicationJob
  queue_as :default

  def perform(document)
    get_number_of_pages(document)
  end

  def get_number_of_pages(document)
    if Cloudinary::Api.resource(document.photo.file.public_id, pages: true)["pages"]
      document.update(pages: Cloudinary::Api.resource(document.photo.file.public_id, pages: true)["pages"])
    end
  end
end
