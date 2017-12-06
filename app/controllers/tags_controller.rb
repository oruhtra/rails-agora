class TagsController < ApplicationController
  def create
    @tag = Tag.new
    @document = Document.find(params[:document_id])

    authorize @tag

    if Tag.tag_from_tagnames([params[:tag][:name].downcase]).first.nil?
      @tag.save
      @tag.update(tag_params)
    else
      @tag = Tag.tag_from_tagnames([params[:tag][:name].downcase]).first
    end

    if !@document.tags.include?(@tag)
      @doctag = Doctag.new
      @doctag.document = @document
      @doctag.tag = @tag
      @doctag.save
    end
    redirect_to document_path(@document)
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end
end
