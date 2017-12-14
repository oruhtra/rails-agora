class Service < ApplicationRecord
  has_many :users, through: :user_services

  validates :macro_category, inclusion: { in: %w(documents_personnels poste banque assurance mutuelle sécurité_sociale internet impôts etudes logement voyage emploi transport sports voiture scooter electroménager mùeubles énergie retraite téléphonie santé)}
end
