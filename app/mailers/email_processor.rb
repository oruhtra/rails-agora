class EmailProcessor
  def initialize(email)
    @email = email
  end

  def process
    @user = User.find_by(email: @email.from[:email])

    if @user
      # remove garbage collection on tempfiles so that Sidekiq can access them
      @email.attachments.each {|t| ObjectSpace.undefine_finalizer(t.tempfile)}
      # Griddler Email to hash for Sidekiq
      email = {
          attachments: @email.attachments.map {|att| {
              type: att.content_type,
              name: att.original_filename.include?('=?UTF-8?') ? "unknown#{Rack::Mime::MIME_TYPES.invert[att.content_type]}" : att.original_filename,
              path: att.tempfile.path
          }},
          body: @email.body,
          subject: @email.subject,
      }

      ProcessEmailJob.perform_later(@user, email)
    end
  end

end
