p "Destroy users, tags, documents"
User.destroy_all
Document.destroy_all
Tag.destroy_all
Doctag.destroy_all

p "Creating the current_user"

myuser = User.new(email: "test@mail.com",  password: "123456" )
myuser.remote_photo_url = "http://www.annonceschatons.fr/wp-content/uploads/2017/07/il_existe_d__sormais_un_parfum_qui_sent_la_fourrure_de_chaton_28.jpeg_north_1200x_white.jpg"
myuser.save

p "Creating tag table"

p "- creating macro cat tags"
#Macro-cat
macro_cat_up = [
  "Documents personnels",
  "Banque",
  "Assurance",
  "Mutuelle",
  "Sécurité Sociale",
  "Impôts",
  "Etudes",
  "Logement",
  "Voyage",
  "Emploi",
  "Transport",
  "Sports",
  "Voiture",
  "Scooter",
  "Electroménager",
  "Meubles",
  "Gaz",
  "Electricité",
  "Retraite",
  "Téléphonie",
  "Santé"
]
macro_cat = macro_cat_up.map { |e| e.downcase.gsub(/\s/, "_") }


macro_cat.each do |tag|
  Tag.create(name: tag)
end

p "- creating type of doc tags"
#Type of document
type_of_doc_up = [
"Carte d'identité",
"Passeport",
"Permis de conduire",
"Carte vitale",
"Carte de mutuelle",
"Carte bancaire",
"Carnet de santé",
"Livret de famille",
"Carte grise",
"RIB",
"Relevé de compte",
"Contrat de prêt",
"Attestation",
"Contrat",
"Relevé de remboursement",
"Quittance de loyer",
"Facture",
"Echéancier",
"Avis d'imposition",
"Déclaration d'impôts",
"Facture",
"Garantie",
"Fiche de paye",
"Contrat de travail",
"Diplômes",
"Ordonances",
"Inscription",
]

type_of_doc = type_of_doc_up.map { |e| e.downcase.gsub(/\s/, "_") }

type_of_doc.each do |tag|
  Tag.create(name: tag)
end

p "- creating fournisseur tags"
#Fournisseur
fournisseurs_up = [
"BNP",
"Société Générale",
]

fournisseurs = fournisseurs_up.map { |e| e.downcase.gsub(/\s/, "_") }

fournisseurs.each do |tag|
  Tag.create(name: tag)
end



