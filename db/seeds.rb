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
macro_cat = [
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

macro_cat.each do |tag|
  Tag.create(name: tag.downcase)
end

p "- creating type of doc tags"
#Type of document
type_of_doc = [
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

type_of_doc.each do |tag|
  Tag.create(name: tag.downcase)
end

p "- creating fournisseur tags"
#Fournisseur
fournisseurs = [
"BNP",
"Société Générale",
]

fournisseurs.each do |tag|
  Tag.create(name: tag.downcase)
end

p "Creating documents"

image =[]
image << "app/assets/images/doctest/Certificat-de-scolarite.pdf"
image << "app/assets/images/doctest/RIB.pdf"
image << "app/assets/images/doctest/facture_directenergy_HG.pdf"
image << "app/assets/images/doctest/carte-identite.jpeg"
image << "app/assets/images/doctest/passeport.jpg"


p "Attributing tags to documents"

master_array = macro_cat|type_of_doc|fournisseurs

30.times do |i|
  random = image.sample
  mydoc = Document.new(name: random)
  mydoc.remote_photo_url = random
  mydoc.user = myuser
  mydoc.save

  5.times do
  d1 = Doctag.new
  d1.document = mydoc
  d1.tag = Tag.find_by_name(master_array.sample)
  d1.save
  end
end



