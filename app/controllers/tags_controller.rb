class TagsController < ApplicationController
  def create
    @tag = Tag.new
    @document = Document.find(params[:document_id])

    authorize @tag
    # get user query and replace " " by _
    @tag_name = params[:tag][:name].downcase.gsub(/\s/, "_")
    # check if tag already exist by searching by tag.name instead of tag.id, if it doesn't exist create it
    if Tag.tag_from_tagnames([@tag_name]).first.nil?
      @tag.name = @tag_name
      @tag.save
    else
      @tag = Tag.tag_from_tagnames([@tag_name]).first
    end
    # check if document doesn't already include the tag, if it doesn't create a new doctag
    if !@document.tags.include?(@tag)
      @doctag = Doctag.new
      @doctag.document = @document
      @doctag.tag = @tag
      @doctag.save
    end
    redirect_to document_path(@document)
  end
end
