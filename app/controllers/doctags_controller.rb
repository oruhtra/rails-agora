class DoctagsController < ApplicationController
  before_action :set_doctag, only: :destroy
  before_action :set_document, only: :create

  def create
    @doctag = Doctag.new
    @doctag.document = @document
    @doctag.tag = Tag.find(params[:tag])
    @doctag.save
    redirect_to document_path(@document)
  end

  def destroy
    @document = @doctag.document
    @doctag.destroy
    redirect_to document_path(@document)
  end

  private

  def set_document
    @document = Document.find(params[:document_id])
  end

  def set_doctag
    @doctag = Doctag.find(params[:id])
  end
end
