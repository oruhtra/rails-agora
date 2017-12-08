class TagsController < ApplicationController
  def create
    @tag = Tag.new
    @document = Document.find(params[:document_id])

    authorize @tag
    @tag_name = params[:tag][:name].downcase.gsub(/\s/, "_")

    if Tag.tag_from_tagnames([@tag_name]).first.nil?
      @tag.name = @tag_name
      @tag.save
    else
      @tag = Tag.tag_from_tagnames([@tag_name]).first
    end

    if !@document.tags.include?(@tag)
      @doctag = Doctag.new
      @doctag.document = @document
      @doctag.tag = @tag
      @doctag.save
    end
    redirect_to document_path(@document)
  end
end
