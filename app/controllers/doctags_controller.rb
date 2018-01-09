class DoctagsController < ApplicationController
  before_action :set_doctag, only: :destroy
  before_action :set_document, only: :create

  def create
    @doctag = Doctag.new
    @doctag.document = @document
    @doctag.tag = Tag.find(params[:tag])
    @doctag.source = "user_added"

    authorize @doctag

    @doctag.save
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @document = @doctag.document

    authorize @doctag

    @doctag.destroy
    redirect_back(fallback_location: root_path)
  end

  private

  def set_document
    @document = Document.find(params[:document_id])
  end

  def set_doctag
    @doctag = Doctag.find(params[:id])
  end
end
