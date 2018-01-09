p "Destroy users, tags, documents and services"
# User.destroy_all
Document.destroy_all
Tag.destroy_all
# Doctag.destroy_all
# UserService.destroy_all
# Service.destroy_all

# p "Creating the current_user"

# myuser = User.new(email: "arthur.reboul@gmail.com",  password: "123456" )
# myuser.remote_photo_url = "https://media-exp1.licdn.com/mpr/mpr/shrink_100_100/p/3/000/22a/280/2401593.jpg"
# myuser.save

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
  "énergie",
  "Retraite",
  "Téléphonie",
  "Santé"
]
macro_cat = macro_cat_up.map { |e| e.downcase.gsub(/\s/, "_") }


macro_cat.each do |tag|
  Tag.create(name: tag, category: "macro_category")
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
  Tag.create(name: tag, category: "doc_type")
end

p "- creating fournisseur tags"
#Fournisseur
fournisseurs_up = [
"BNP",
"Société Générale",
]

fournisseurs = fournisseurs_up.map { |e| e.downcase.gsub(/\s/, "_") }

fournisseurs.each do |tag|
  Tag.create(name: tag, category: "supplier")
end

# # p "creating services to connect"

# my_service = Service.new(name: "Ameli", budgea_id: 50, macro_category: "sécurité_sociale")
# my_service.logo = "http://is3.mzstatic.com/image/thumb/Purple127/v4/64/e1/92/64e1921c-3afe-7d95-5598-8b9e70a7e94d/source/1200x630bb.jpg"
# my_service.save

# my_service = Service.new(name: "CAF", budgea_id: 73, macro_category: "logement")
# my_service.logo = "https://www.caf.fr/maintenance/images/new_logo.jpg"
# my_service.save

# my_service = Service.new(name: "Pôle Emploi", budgea_id: 100, macro_category: "emploi")
# my_service.logo= "https://upload.wikimedia.org/wikipedia/fr/thumb/c/cd/Logo_P%C3%B4le_Emploi.png/922px-Logo_P%C3%B4le_Emploi.png"
# my_service.save

# my_service = Service.new(name: "Dropbox", budgea_id: 580, macro_category: "internet")
# my_service.logo = "https://aem.dropbox.com/cms/content/dam/dropbox/www/en-us/branding/app-dropbox-windows@2x.png"
# my_service.save

# my_service = Service.new(name: "Red by SFR", budgea_id: 96, macro_category: "téléphonie")
# my_service.logo = "http://www.sfr.com/sites/default/files/sfr.jpg"
# my_service.save

# my_service = Service.new(name: "Bouygues Telecom", budgea_id: 98, macro_category: "téléphonie")
# my_service.logo = "http://www.mega-bonnes-affaires.com/wp-content/uploads/2015/11/logo-bouygues-telecom.jpg"
# my_service.save

# my_service = Service.new(name: "Orange", budgea_id: 56, macro_category: "téléphonie")
# my_service.logo = "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c8/Orange_logo.svg/1024px-Orange_logo.svg.png"
# my_service.save

# my_service = Service.new(name: "Free Mobile", budgea_id: 49, macro_category: "téléphonie")
# my_service.logo = "http://www.ariase.com/fr/news/media/logo-free-intro.jpg"
# my_service.save

# my_service = Service.new(name: "AXA", budgea_id: 131, macro_category: "assurance")
# my_service.logo = "https://www.axa.fr/etc/designs/axa/axa-fr-desktop/clientlib_publish/img/logo/logo-axa-new.svg"
# my_service.save

# my_service = Service.new(name: "Direct Energie", budgea_id: "350", macro_category: "énergie")
# my_service.logo = "https://selectra.info/sites/default/files/field/image/direct-energie-xl.png"
# my_service.save

# my_service = Service.new(name: "Maïf", budgea_id: 103, macro_category: "assurance")
# my_service.logo = "https://www.maif.fr/content/imagesReseaux/logo-maif.svg"
# my_service.save

# my_service = Service.new(name: "La Poste", budgea_id: 334, macro_category: "poste")
# my_service.logo = "https://upload.wikimedia.org/wikipedia/fr/2/2a/Logo-laposte.png"
# my_service.save

