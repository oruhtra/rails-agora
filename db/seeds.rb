# Tag.create(name: "énergie", category: "macro_category")

# Tag.find_by(name: 'electricité').update(name: 'électricité')
# Tag.find_by(name: 'electroménager').update(name: 'électroménager')
# Tag.find_by(name: 'etudes').update(name: 'études')
# Tag.find_by(name: 'fiche_de_paye').update(name: 'fiche_de_paie')
p 'destruction des prototypes'
Document.where(prototype: true).destroy_all

p 'création des prototypes'
prototypes = [
  {name:'carte d\'identité', photo:'https://www.exilphoto.com/sites/default/files/2017-07/99588.jpg'},
  {name:'facture edf', photo:'https://www.nouvellecartegrise.fr/wp-content/uploads/2016/05/justificatif-de-domicile.jpg'},
  {name:'carte grise', photo:'https://www.nouvellecartegrise.fr/wp-content/uploads/2016/05/nouvelle-carte-grise-specimen.jpg'},
  {name:'permis de conduire', photo:'https://www.interieur.gouv.fr/var/miomcti/storage/images/www.interieur.gouv.fr/version-fre/actualites/l-actu-du-ministere/nouveau-permis-de-conduire-securise-le-16-septembre-2013/466172-1-fre-FR/Nouveau-permis-de-conduire-securise-le-16-septembre-2013_largeur_445.jpg'},
  {name:'fiche de paie', photo:'http://www.ruedelapaye.com/wp-content/uploads/2017/02/exemple-fiche-de-paie-2017.jpg'},
  {name:'facture free', photo:'http://free.fr/assistance/im/faq/assistance/Factures/1447/Facture-1447-SPECIMEN.png'},
  {name:'attestation Pôle Emploi', photo:'http://www.aladom.fr/media/upload/pole-emploi/attestation-pole-emploi.jpg'},
  {name:'déclaration d\'impôts', photo:'http://internationaloffice.ceasaclay.com/local/cache-vignettes/L150xH218/vignette_cerfa2042-2-2e1d1.jpg'},
  {name:'rib', photo:'http://www.pixelistes.com/forum/gallery/nikonol-a8103/rib-iban-patrick-pichon-jpg-m577871.jpg'},
  {name:'attestation d\'assurance', photo:'http://ericgaubiac.e-monsite.com/medias/images/attestation-rd-2.jpg?fx=r_550_550'},
  {name:'attestation de sécurité sociale', photo:'http://www.lamodedeshommes.com/wp-content/uploads/2017/05/attestation-securite-sociale-1.jpg'}
]


p 'persisting prototypes'
prototypes.each do |doc|
  cl_response = Cloudinary::Uploader.upload(doc[:photo])
  p cl_response
  d = Document.new
  d.name = doc[:name]
  d.prototype = true
  d.source = 'prototype'
  d.remote_photo_url = cl_response["secure_url"]
  d.save
  p 'prototype added'
  Cloudinary::Uploader.destroy(cl_response["public_id"])
  d = Document.find(d.id)
  d.update(ratio: d.get_image_ratio)
end


# p "Destroy tags, documents"
# Doctag.destroy_all
# Document.destroy_all
# # UserService.destroy_all
# Tag.destroy_all
# # Service.destroy_all


# p "- creating macro cat tags"
# #Macro-cat
# macro_cat_up = [
#   "Documents personnels",
#   "Banque",
#   "Assurance",
#   "Mutuelle",
#   "Sécurité Sociale",
#   "Impôts",
#   "Etudes",
#   "Logement",
#   "Voyage",
#   "Emploi",
#   "Transport",
#   "Sports",
#   "Véhicule",
#   "Electroménager",
#   "Meubles",
#   "Gaz",
#   "Electricité",
#   "Retraite",
#   "Téléphonie",
#   "Santé",
#   "Poste"
# ]
# macro_cat = macro_cat_up.map { |e| e.downcase.gsub(/\s/, "_") }


# macro_cat.each do |tag|
#   Tag.create(name: tag, category: "macro_category")
# end

# p "- creating type of doc tags"
# #Type of document

# type_of_doc_up = [
# {name:"Carte d'identité", macro_category:["Documents personnels"]},
# {name:"Passeport", macro_category:["Documents personnels"]},
# {name:"Permis de conduire", macro_category:["Documents personnels"]},
# {name:"Carte vitale", macro_category:["Documents personnels","Sécurité Sociale","Santé"]},
# {name:"Carte de mutuelle", macro_category:["Documents personnels","Mutuelle","Santé"]},
# {name:"Carte bancaire", macro_category:["Documents personnels","Banque"]},
# {name:"Carnet de santé", macro_category:["Documents personnels","Santé"]},
# {name:"Livret de famille", macro_category:["Documents personnels"]},
# {name:"Carte grise", macro_category:["Documents personnels","Véhicule"]},
# {name:"RIB", macro_category:["Banque"]},
# {name:"Relevé", macro_category:["Banque","Assurance","Mutuelle","Sécurité Sociale","Impôts","Logement","Emploi","Transport","Véhicule","Gaz","Electricité","Retraite","Téléphonie"]},
# {name:"Attestation", macro_category:["Banque","Assurance","Mutuelle","Sécurité Sociale","Impôts","Etudes","Logement","Emploi","Transport","Véhicule","Gaz","Electricité","Retraite","Téléphonie","Santé"]},
# {name:"Contrat", macro_category:["Banque","Assurance","Mutuelle","Sécurité Sociale","Impôts","Etudes","Logement","Emploi","Transport","Véhicule","Gaz","Electricité","Retraite","Téléphonie","Santé"]},
# {name:"Quittance de loyer", macro_category:["Logement"]},
# {name:"Facture", macro_category:["Banque","Assurance","Mutuelle","Sécurité Sociale","Impôts","Etudes","Logement","Emploi","Transport","Véhicule","Gaz","Electricité","Retraite","Téléphonie","Santé","Biens personnels"]},
# {name:"Echéancier", macro_category:["Banque","Assurance","Mutuelle","Impôts","Gaz","Electricité","Téléphonie"]},
# {name:"Avis", macro_category:["Impôts"]},
# {name:"Déclaration", macro_category:["Impôts"]},
# {name:"Taxe d'habitation", macro_category:["Impôts", "Logement"]},
# {name:"Garantie", macro_category:["Banque","Assurance","Mutuelle","Sécurité Sociale","Impôts","Logement","Voyage","Emploi","Véhicule","Téléphonie","Biens personnels"]},
# {name:"Fiche de paye", macro_category:["Emploi"]},
# {name:"Diplôme", macro_category:["Etudes","Sports"]},
# {name:"Ordonance", macro_category:["Santé","Mutuelle","Sécurité Sociale"]},
# {name:"Inscription", macro_category:["Banque","Assurance","Mutuelle","Sécurité Sociale","Impôts","Etudes","Voyage","Transport","Sports","Véhicule","Gaz","Electricité","Retraite","Téléphonie","Santé"]},
# {name:"Abonnement", macro_category:["Banque","Assurance","Mutuelle","Etudes","Transport","Sports","Véhicule","Gaz","Electricité","Téléphonie"]},
# {name:"Notification", macro_category:["All"]},
# {name:"Avis de situation", macro_category:["Banque","Assurance","Mutuelle","Sécurité Sociale","Impôts","Etudes","Logement","Emploi","Véhicule","Gaz","Electricité","Retraite","Téléphonie","Santé"]}
# ]

# type_of_doc = type_of_doc_up.each do |t|
#   t[:name].downcase!.gsub!(/\s/, "_")
#   t[:macro_category].each do |c|
#     c.downcase!.gsub!(/\s/, "_")
#   end
# end

# type_of_doc.each do |t|
#   if t[:macro_category].include?("all")
#     Tag.create(name: t[:name], category: "doc_type", macro_category: macro_cat.join(','))
#   else
#     Tag.create(name: t[:name], category: "doc_type", macro_category: t[:macro_category].join(','))
#   end
# end

# my_services = []

# p "creating services to connect"

# p "creating Assurances"
# my_services += [
#   {name:"Axa", budgea_id: 131, macro_category: "assurance", logo: "https://www.axa.fr/etc/designs/axa/axa-fr-desktop/clientlib_publish/img/logo/logo-axa-new.svg"},
#   {name: "Maïf", budgea_id: 103, macro_category: "assurance", logo: "https://www.maif.fr/content/imagesReseaux/logo-maif.svg"},
#   {name: "Allianz", budgea_id: 333, macro_category: "assurance", logo: "https://botw-pd.s3.amazonaws.com/styles/logo-thumbnail/s3/0014/3192/brand.gif?itok=0O9A626H"},
#   {name: "Assurances Aviva", budgea_id: 125, macro_category: "assurance", logo: "http://www.sow-csp.fr/wp-content/uploads/2017/01/aviva-logo-primary.gif"},
#   {name: "Direct Assurances", budgea_id: 160, macro_category: "assurance", logo: "https://www.direct-assurance.fr/Sales/ContentStore/?filename=/logo-direct-assurance.png&tx=MzoxOjExOjE1OjM6MQ=="},
#   {name: "Matmut", budgea_id: 213, macro_category: "assurance", logo: "http://www.assurance-guide.com/wordpress/wp-content/uploads/2013/03/matmut-logo-300x209@2x.gif"},
#   {name: "GMF", budgea_id: 184, macro_category: "assurance", logo: "https://upload.wikimedia.org/wikipedia/fr/thumb/9/99/GMF_logo.svg/1020px-GMF_logo.svg.png"},
#   {name: "Maaf", budgea_id: 1077, macro_category: "assurance", logo: "https://upload.wikimedia.org/wikipedia/fr/4/49/Logo_Maaf_2007.jpg"},
#   {name: "MMA", budgea_id: 221, macro_category: "assurance", logo: "https://www.index-habitation.fr/wp-content/uploads/logo-mma-768x512.jpg"},
#   {name: "Groupama", budgea_id: 186, macro_category: "assurance", logo: "http://ta-mutuelle.org/wp-content/uploads/2014/07/groupama-mutuelle-santé.jpg"},
#   {name: "Macif", budgea_id: 210, macro_category: "assurance", logo: "https://upload.wikimedia.org/wikipedia/fr/6/6d/Macif_logo.gif"},
#   {name: "Amaguiz", budgea_id: 121, macro_category: "assurance", logo: "https://www.index-assurance.fr/fichiers/images/logo-amaguiz.jpg"}
# ]

# p "creating Mutuelles"

# my_services += [
#   {name: "GMC / Henner", budgea_id: 235, macro_category: "mutuelle", logo: "https://compteassurance.com/wp-content/uploads/2016/03/henner-mon-espace-client.png"},
#   {name: "Mutuelle AG2R - La Mondiale", budgea_id: 228, macro_category: "mutuelle", logo: "https://presse.ag2rlamondiale.fr/media/cache/no_filter_grid_fs/575aa50760cb7dc1008b4741"},
#   {name: "Mutuelle April", budgea_id: 230, macro_category: "mutuelle", logo: "https://www.automobileassurance.fr/images/logos%20mutuelle/april.jpg"},
#   {name: "Mutuelle Arpege", budgea_id: 232, macro_category: "mutuelle", logo: "https://media.glassdoor.com/sql/845750/groupe-arpege-squarelogo-1407848228448.png"},
#   {name: "Mutuelle Generale", budgea_id: 233, macro_category: "mutuelle", logo: "https://www.adventori.com/media/La_Mutuelle_Generale-1.jpg"},
#   {name: "Mutuelle Gras Savoye", budgea_id: 236, macro_category: "mutuelle", logo: "https://upload.wikimedia.org/wikipedia/fr/thumb/3/35/Logo_gras_savoye.png/560px-Logo_gras_savoye.png"},
#   {name: "Mutuelle Groupama", budgea_id: 237, macro_category: "mutuelle", logo: "http://ta-mutuelle.org/wp-content/uploads/2014/07/groupama-mutuelle-santé.jpg"},
#   {name: "Mutuelle Groupe Uneo", budgea_id: 238, macro_category: "mutuelle", logo: "http://sa-mutuelle.com/wp-content/uploads/groupe-uneo.jpg"},
#   {name: "Mutuelle LMDE", budgea_id: 242, macro_category: "mutuelle", logo: "http://www.planetecampus.com/wp-content/uploads/2014/10/lmde-mutuelle-etudiante.jpg"},
#   {name: "Mutuelle Malakoff Médéric", budgea_id: 243, macro_category: "mutuelle", logo: "http://comparer-mutuelle.net/wp-content/uploads/2014/09/malakoff-mederic-logo.jpg"},
#   {name: "Mutuelle Mercer", budgea_id: 244, macro_category: "mutuelle", logo: "http://services-client.net/wp-content/uploads/mercer-mutuelle.jpg"},
#   {name: "Mutuelle Vivinter", budgea_id: 252, macro_category: "mutuelle", logo: "http://cecrit.com/sites/cecrit.com/IMG/UserFiles/Images/logo_vivinter.jpg"}
# ]

# p "creating Téléphonie"
# my_services += [
#   {name: "Red by SFR", budgea_id: 96, macro_category: "téléphonie", logo: "https://upload.wikimedia.org/wikipedia/fr/thumb/4/4f/Logo_RED_by_SFR.png/1600px-Logo_RED_by_SFR.png"},
#   {name: "SFR", budgea_id: 76, macro_category: "téléphonie", logo: "http://www.sfr.com/sites/default/files/sfr.jpg"},
#   {name: "B&You", budgea_id: 98, macro_category: "téléphonie", logo: "http://www.mega-bonnes-affaires.com/wp-content/uploads/2015/11/logo-bouygues-telecom.jpg"},
#   {name: "Orange", budgea_id: 56, macro_category: "téléphonie", logo:"https://upload.wikimedia.org/wikipedia/commons/thumb/c/c8/Orange_logo.svg/1024px-Orange_logo.svg.png"},
#   {name: "Free Mobile", budgea_id: 49, macro_category: "téléphonie", logo:"http://www.ariase.com/fr/news/media/logo-free-intro.jpg"},
#   {name: "Sosh", budgea_id: 97, macro_category: "téléphonie", logo:"https://upload.wikimedia.org/wikipedia/fr/thumb/7/7d/Sosh_%28logo_bleu%29.svg/262px-Sosh_%28logo_bleu%29.svg.png"},
#   {name: "Virgin mobile", budgea_id: 332, macro_category: "téléphonie", logo:"https://botw-pd.s3.amazonaws.com/styles/logo-thumbnail/s3/102013/virgin_mobile.png?itok=Mkx5nV77"}
# ]

# p "creating Logement"
# my_services += [
#   {name: "CAF", budgea_id: 73, macro_category: "logement", logo: "https://www.caf.fr/maintenance/images/new_logo.jpg"}
# ]

# p "creating Impôts"
# my_services += [
#   {name: "Impôts", budgea_id: 340 , macro_category: "impôts", logo: "http://lamotheachard.com/wp-content/uploads/2016/08/impots_logo.jpg"}
# ]

# p "creating Sécurité sociale"
# my_services += [
#   {name: "Ameli", budgea_id: 50, macro_category: "sécurité_sociale", logo: "http://is3.mzstatic.com/image/thumb/Purple127/v4/64/e1/92/64e1921c-3afe-7d95-5598-8b9e70a7e94d/source/1200x630bb.jpg"},
#   {name: "CNMSS", budgea_id: 151, macro_category: "sécurité_sociale", logo: "http://deploiement.cnmss.fr/fileadmin/Images/_logos/logo_illustration_cnmss.jpg"},
#   {name: "Ameli Pro", budgea_id: 51, macro_category: "sécurité_sociale", logo: "http://risquesprofessionnels2016.fr/images/logo.svg"}
# ]

# p "creating Energie"
# my_services += [
#   {name: "Direct Energie", budgea_id: "350", macro_category: "énergie", logo: "https://selectra.info/sites/default/files/field/image/direct-energie-xl.png"},
#   {name: "EDF", budgea_id: "52", macro_category: "énergie", logo: "https://upload.wikimedia.org/wikipedia/commons/thumb/1/12/Électricité_de_France_logo.svg/560px-Électricité_de_France_logo.svg.png"},
#   {name: "Engie", budgea_id: "53", macro_category: "énergie", logo: "https://particuliers.engie.fr/etc/designs/particuliers/images/logo-engie.svg"}
# ]

# p "creating Transport"
# my_services += [
#   {name: "Autolib.eu", budgea_id: 130, macro_category: "transport", logo: "https://bibliopi.files.wordpress.com/2015/05/autolib-logo-vector-image1.png"},
#   {name: "Uber", budgea_id: 327, macro_category: "transport", logo: "https://botw-pd.s3.amazonaws.com/styles/logo-thumbnail/s3/122013/uber_logo_0.png?itok=nIsy3NXD"},
#   {name: "Chauffeur privé", budgea_id: 733, macro_category: "transport", logo: "https://app.chauffeur-prive.com/images/logotext.svg"},
#   {name: "CityScoot", budgea_id: 150, macro_category: "transport", logo: "https://upload.wikimedia.org/wikipedia/commons/6/6f/Cityscoot_logo.png"}
# ]

# p "creating Emploi"
# my_services += [
#   {name: "Pôle emploi", budgea_id: 100, macro_category: "emploi", logo: 'https://upload.wikimedia.org/wikipedia/fr/thumb/c/cd/Logo_P%C3%B4le_Emploi.png/922px-Logo_P%C3%B4le_Emploi.png'}
# ]

# p "creating Poste"
# my_services += [
#   {name: "La Poste", budgea_id: 334, macro_category: "poste", logo: 'https://upload.wikimedia.org/wikipedia/fr/2/2a/Logo-laposte.png'}
# ]

# # p "persisiting all services"

# # i = 1
# # my_services.each do |s|
# #   s[:name] = s[:name].downcase.gsub(/\s/, "_")

# #   # s[:budgea_name] = s[:budgea_name].downcase
# #   # if s[:name].nil?
# #   #   s[:name] = s[:budgea_name].titleize
# #   # end

# #   my_service = Service.new(s)
# #   cl_response = Cloudinary::Uploader.upload(s[:logo])
# #   my_service.remote_logo_url = cl_response["secure_url"]
# #   my_service.save
# #   Cloudinary::Uploader.destroy(cl_response["public_id"])
# #   p "#{i} added"
# #   i += 1
# # end

# p "creating fournisseur tags"
# #Fournisseur

# my_services.each do |s|
#   Tag.create(name: s[:name].downcase.gsub(/\s/, "_"), category: "supplier", macro_category:s[:macro_category].downcase.gsub(/\s/, "_"))
# end

# p 'creating other suppliers'

# other_suppliers = [
# {name:'BNP', macro_category:'Banque,Assurance'},
# {name:'Société Générale', macro_category:'Banque,Assurance'},
# {name:'Banque Populaire', macro_category:'Banque,Assurance'},
# {name:'LCL', macro_category:'Banque,Assurance'},
# {name:'Crédit Lyonnais', macro_category:'Banque,Assurance'},
# {name:'CIC', macro_category:'Banque,Assurance'},
# {name:'Caisse d\'Epargne', macro_category:'Banque,Assurance'},
# {name:'BforBanque', macro_category:'Banque,Assurance'},
# {name:'Crédit mutuel', macro_category:'Banque,Assurance'},
# {name:'Crédit Agricole', macro_category:'Banque,Assurance'},
# {name:'Boursorama', macro_category:'Banque,Assurance'},
# {name:'HSBC', macro_category:'Banque,Assurance'},
# {name:'Fortuneo', macro_category:'Banque'},
# {name:'Hello bank!', macro_category:'Banque'},
# {name:'ING Directe', macro_category:'Banque,Assurance'},
# {name:'Banque Postale', macro_category:'Banque,Assurance'},
# {name:'N26', macro_category:'Banque'},
# {name:'Revolut', macro_category:'Banque'},
# ]


# other_suppliers.each do |s|
#   Tag.create(name: s[:name].downcase.gsub(/\s/, "_"), category: "supplier", macro_category:s[:macro_category].downcase.gsub(/\s/, "_"))
# end

