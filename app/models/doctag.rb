class Doctag < ApplicationRecord
  belongs_to :document
  belongs_to :tag
  has_one :user, through: :document

  validates :source, presence: true, inclusion: { in: %w(user_added automatic)}
end
