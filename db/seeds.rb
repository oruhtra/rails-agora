p "Destroy users, tags, documents and services"
User.destroy_all
Document.destroy_all
Tag.destroy_all
Doctag.destroy_all
Service.destroy_all

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

p "creating services to connect"

my_service = Service.new(name: "Ameli", budgea_id: 50)
my_service.logo = "https://www.ordissinaute.fr/sites/default/files/styles/full_new_main/public/field/image/vignette_ameli.jpg?itok=ITl14XyK"
my_service.save

my_service = Service.new(name: "CAF", budgea_id: 73)
my_service.logo = "https://www.caf.fr/maintenance/images/new_logo.jpg"
my_service.save

my_service = Service.new(name: "Pôle Emploi", budgea_id: 100)
my_service.logo= "https://upload.wikimedia.org/wikipedia/fr/thumb/c/cd/Logo_P%C3%B4le_Emploi.png/922px-Logo_P%C3%B4le_Emploi.png"
my_service.save

my_service = Service.new(name: "SFR", budgea_id: 96)
my_service.logo = "http://www.sfr.com/sites/default/files/sfr.jpg"
my_service.save

my_service = Service.new(name: "Bouygues Telecom", budgea_id: 98)
my_service.logo = "http://www.mega-bonnes-affaires.com/wp-content/uploads/2015/11/logo-bouygues-telecom.jpg"
my_service.save

my_service = Service.new(name: "EDF", budgea_id: 52)
my_service.logo = "http://tous-logos.com/wp-content/uploads/2017/08/Logo-EDF.png"
my_service.save

my_service = Service.new(name: "AXA", budgea_id: 131)
my_service.logo = "http://logok.org/wp-content/uploads/2014/09/AXA_logo.png"
my_service.save
