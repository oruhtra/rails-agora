class TagCategory < ApplicationRecord
  belongs_to :tag
  belongs_to :macro_category, class_name: "Tag"
end
