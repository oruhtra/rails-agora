class EmailProcessor
  def initialize(email)
    @email = email
  end

  def process
    @user = User.find_by(email: @email.from[:email])
    if @user
      attachments = []
      # remove garbage collection on tempfiles so that Sidekiq can access them
      @email.attachments.each do |d|
        # upload file to cloudinary and store cloudinary response to pass it to the worker (can't pass a temp file as they are not located on the same machine at Heroku)
        begin
          cl_response = Cloudinary::Uploader.upload(d.tempfile.path, :phash => true)
        rescue
          cl_response = nil
        end
        attachments += [{
          name: d.original_filename.include?('=?UTF-8?') ? "unknown#{Rack::Mime::MIME_TYPES.invert[att.content_type]}" : d.original_filename,
          cl_response: cl_response
        }]
      end
      # Griddler Email to hash for Sidekiq
      email = {
          attachments: attachments,
          body: @email.body,
          subject: @email.subject,
      }

      ProcessEmailJob.perform_later(@user, email)
    end
  end

end
