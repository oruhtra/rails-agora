p "Destroy users, tags, documents and services"
Doctag.destroy_all
Document.destroy_all
UserService.destroy_all
Tag.destroy_all
Service.destroy_all
# User.destroy_all

# p "Creating the current_user"

# myuser = User.new(email: "arthur.reboul@gmail.com",  password: "123456" )
# myuser.remote_photo_url = "https://media-exp1.licdn.com/mpr/mpr/shrink_100_100/p/3/000/22a/280/2401593.jpg"
# myuser.save

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
  "Véhicule",
  "Electroménager",
  "Meubles",
  "Gaz",
  "Electricité",
  "Retraite",
  "Téléphonie",
  "Santé",
  "Poste"
]
macro_cat = macro_cat_up.map { |e| e.downcase.gsub(/\s/, "_") }


macro_cat.each do |tag|
  Tag.create(name: tag, category: "macro_category")
end

p "- creating type of doc tags"
#Type of document

type_of_doc_up = [
{name:"Carte d'identité", macro_category:["Documents personnels"]},
{name:"Passeport", macro_category:["Documents personnels"]},
{name:"Permis de conduire", macro_category:["Documents personnels"]},
{name:"Carte vitale", macro_category:["Documents personnels","Sécurité Sociale","Santé"]},
{name:"Carte de mutuelle", macro_category:["Documents personnels","Mutuelle","Santé"]},
{name:"Carte bancaire", macro_category:["Documents personnels","Banque"]},
{name:"Carnet de santé", macro_category:["Documents personnels","Santé"]},
{name:"Livret de famille", macro_category:["Documents personnels"]},
{name:"Carte grise", macro_category:["Documents personnels","Véhicule"]},
{name:"RIB", macro_category:["Banque"]},
{name:"Relevé", macro_category:["Banque","Assurance","Mutuelle","Sécurité Sociale","Impôts","Logement","Emploi","Transport","Véhicule","Gaz","Electricité","Retraite","Téléphonie"]},
{name:"Attestation", macro_category:["Banque","Assurance","Mutuelle","Sécurité Sociale","Impôts","Etudes","Logement","Emploi","Transport","Véhicule","Gaz","Electricité","Retraite","Téléphonie","Santé"]},
{name:"Contrat", macro_category:["Banque","Assurance","Mutuelle","Sécurité Sociale","Impôts","Etudes","Logement","Emploi","Transport","Véhicule","Gaz","Electricité","Retraite","Téléphonie","Santé"]},
{name:"Quittance de loyer", macro_category:["Logement"]},
{name:"Facture", macro_category:["Banque","Assurance","Mutuelle","Sécurité Sociale","Impôts","Etudes","Logement","Emploi","Transport","Véhicule","Gaz","Electricité","Retraite","Téléphonie","Santé","Biens personnels"]},
{name:"Echéancier", macro_category:["Banque","Assurance","Mutuelle","Impôts","Gaz","Electricité","Téléphonie"]},
{name:"Avis d'imposition", macro_category:["Impôts"]},
{name:"Déclaration d'impôts", macro_category:["Impôts"]},
{name:"Garantie", macro_category:["Banque","Assurance","Mutuelle","Sécurité Sociale","Impôts","Logement","Voyage","Emploi","Véhicule","Téléphonie","Biens personnels"]},
{name:"Fiche de paye", macro_category:["Emploi"]},
{name:"Diplôme", macro_category:["Etudes","Sports"]},
{name:"Ordonance", macro_category:["Santé","Mutuelle","Sécurité Sociale"]},
{name:"Inscription", macro_category:["Banque","Assurance","Mutuelle","Sécurité Sociale","Impôts","Etudes","Voyage","Transport","Sports","Véhicule","Gaz","Electricité","Retraite","Téléphonie","Santé"]},
{name:"Abonnement", macro_category:["Banque","Assurance","Mutuelle","Etudes","Transport","Sports","Véhicule","Gaz","Electricité","Téléphonie"]},
{name:"Notification", macro_category:["All"]},
{name:"Avis de situation", macro_category:["Banque","Assurance","Mutuelle","Sécurité Sociale","Impôts","Etudes","Logement","Emploi","Véhicule","Gaz","Electricité","Retraite","Téléphonie","Santé"]}
]

type_of_doc = type_of_doc_up.each do |t|
  t[:name].downcase!.gsub!(/\s/, "_")
  t[:macro_category].each do |c|
    c.downcase!.gsub!(/\s/, "_")
  end
end

type_of_doc.each do |t|
  if t[:macro_category].include?("all")
    Tag.create(name: t[:name], category: "doc_type", macro_category: macro_cat.join(','))
  else
    Tag.create(name: t[:name], category: "doc_type", macro_category: t[:macro_category].join(','))
  end
end

my_services = []

p "creating services to connect"

p "creating Assurances"
my_services += [
  {name:"Axa", budgea_name: "AXA Assurances et contrats", budgea_id: 131, macro_category: "assurance", logo: "https://www.axa.fr/etc/designs/axa/axa-fr-desktop/clientlib_publish/img/logo/logo-axa-new.svg"},
  {budgea_name: "Maïf", budgea_id: 103, macro_category: "assurance", logo: "https://www.maif.fr/content/imagesReseaux/logo-maif.svg"},
  {budgea_name: "Allianz", budgea_id: 333, macro_category: "assurance", logo: "https://botw-pd.s3.amazonaws.com/styles/logo-thumbnail/s3/0014/3192/brand.gif?itok=0O9A626H"},
  {budgea_name: "Assurances Aviva", budgea_id: 125, macro_category: "assurance", logo: "http://www.sow-csp.fr/wp-content/uploads/2017/01/aviva-logo-primary.gif"},
  {name: "Direct Assurances", budgea_name: "Direct Assurances (contrats)", budgea_id: 160, macro_category: "assurance", logo: "https://www.direct-assurance.fr/Sales/ContentStore/?filename=/logo-direct-assurance.png&tx=MzoxOjExOjE1OjM6MQ=="},
  {name: "Matmut", budgea_name: "Matmut (attestations d'assurance)", budgea_id: 213, macro_category: "assurance", logo: "http://www.assurance-guide.com/wordpress/wp-content/uploads/2013/03/matmut-logo-300x209@2x.gif"},
  {name: "GMF", budgea_name: "Gmf - Contrats", budgea_id: 184, macro_category: "assurance", logo: "https://upload.wikimedia.org/wikipedia/fr/thumb/9/99/GMF_logo.svg/1020px-GMF_logo.svg.png"},
  {budgea_name: "Maaf", budgea_id: 1077, macro_category: "assurance", logo: "https://upload.wikimedia.org/wikipedia/fr/4/49/Logo_Maaf_2007.jpg"},
  {name: "MMA", budgea_name: "MMA Contrats", budgea_id: 221, macro_category: "assurance", logo: "https://www.index-habitation.fr/wp-content/uploads/logo-mma-768x512.jpg"},
  {name: "Groupama", budgea_name: "Groupama (contrats)", budgea_id: 186, macro_category: "assurance", logo: "http://ta-mutuelle.org/wp-content/uploads/2014/07/groupama-mutuelle-santé.jpg"},
  {name: "Macif", budgea_name: "Macif - Avis échéance", budgea_id: 210, macro_category: "assurance", logo: "https://upload.wikimedia.org/wikipedia/fr/6/6d/Macif_logo.gif"},
  {name: "Amaguiz", budgea_name: "Amaguiz (Avis d'échéance)", budgea_id: 121, macro_category: "assurance", logo: "https://www.index-assurance.fr/fichiers/images/logo-amaguiz.jpg"}
]

p "creating Mutuelles"

my_services += [
  {budgea_name: "GMC / Henner", budgea_id: 235, macro_category: "mutuelle", logo: "https://compteassurance.com/wp-content/uploads/2016/03/henner-mon-espace-client.png"},
  {budgea_name: "Mutuelle AG2R - La Mondiale", budgea_id: 228, macro_category: "mutuelle", logo: "https://presse.ag2rlamondiale.fr/media/cache/no_filter_grid_fs/575aa50760cb7dc1008b4741"},
  {budgea_name: "Mutuelle April", budgea_id: 230, macro_category: "mutuelle", logo: "https://www.automobileassurance.fr/images/logos%20mutuelle/april.jpg"},
  {budgea_name: "Mutuelle Arpege", budgea_id: 232, macro_category: "mutuelle", logo: "https://media.glassdoor.com/sql/845750/groupe-arpege-squarelogo-1407848228448.png"},
  {budgea_name: "Mutuelle Generale", budgea_id: 233, macro_category: "mutuelle", logo: "https://www.adventori.com/media/La_Mutuelle_Generale-1.jpg"},
  {budgea_name: "Mutuelle Gras Savoye", budgea_id: 236, macro_category: "mutuelle", logo: "https://upload.wikimedia.org/wikipedia/fr/thumb/3/35/Logo_gras_savoye.png/560px-Logo_gras_savoye.png"},
  {budgea_name: "Mutuelle Groupama", budgea_id: 237, macro_category: "mutuelle", logo: "http://ta-mutuelle.org/wp-content/uploads/2014/07/groupama-mutuelle-santé.jpg"},
  {budgea_name: "Mutuelle Groupe Uneo", budgea_id: 238, macro_category: "mutuelle", logo: "http://sa-mutuelle.com/wp-content/uploads/groupe-uneo.jpg"},
  {budgea_name: "Mutuelle LMDE", budgea_id: 242, macro_category: "mutuelle", logo: "http://www.le-classement.fr/annuaire/wp-content/uploads/2015/01/Logo-LMDE-011.png"},
  {budgea_name: "Mutuelle Malakoff Médéric", budgea_id: 243, macro_category: "mutuelle", logo: "http://comparer-mutuelle.net/wp-content/uploads/2014/09/malakoff-mederic-logo.jpg"},
  {budgea_name: "Mutuelle Mercer", budgea_id: 244, macro_category: "mutuelle", logo: "http://services-client.net/wp-content/uploads/mercer-mutuelle.jpg"},
  {budgea_name: "Mutuelle Vivinter", budgea_id: 252, macro_category: "mutuelle", logo: "http://cecrit.com/sites/cecrit.com/IMG/UserFiles/Images/logo_vivinter.jpg"}
]

p "creating Téléphonie"
my_services += [
  {budgea_name: "Red by SFR", budgea_id: 96, macro_category: "téléphonie", logo: "https://upload.wikimedia.org/wikipedia/fr/thumb/4/4f/Logo_RED_by_SFR.png/1600px-Logo_RED_by_SFR.png"},
  {budgea_name: "SFR", budgea_id: 76, macro_category: "téléphonie", logo: "http://www.sfr.com/sites/default/files/sfr.jpg"},
  {budgea_name: "B&You", budgea_id: 98, macro_category: "téléphonie", logo: "http://www.mega-bonnes-affaires.com/wp-content/uploads/2015/11/logo-bouygues-telecom.jpg"},
  {budgea_name: "Orange", budgea_id: 56, macro_category: "téléphonie", logo:"https://upload.wikimedia.org/wikipedia/commons/thumb/c/c8/Orange_logo.svg/1024px-Orange_logo.svg.png"},
  {budgea_name: "Free Mobile", budgea_id: 49, macro_category: "téléphonie", logo:"http://www.ariase.com/fr/news/media/logo-free-intro.jpg"},
  {budgea_name: "Sosh", budgea_id: 97, macro_category: "téléphonie", logo:"https://upload.wikimedia.org/wikipedia/fr/thumb/7/7d/Sosh_%28logo_bleu%29.svg/262px-Sosh_%28logo_bleu%29.svg.png"},
  {budgea_name: "Virgin mobile", budgea_id: 332, macro_category: "téléphonie", logo:"https://botw-pd.s3.amazonaws.com/styles/logo-thumbnail/s3/102013/virgin_mobile.png?itok=Mkx5nV77"}
]

p "creating Logement"
my_services += [
  {budgea_name: "CAF", budgea_id: 73, macro_category: "logement", logo: "https://www.caf.fr/maintenance/images/new_logo.jpg"}
]

p "creating Impôts"
my_services += [
  {name: "Impôts", budgea_name: "Impots - Avis et declarations", budgea_id: 340 , macro_category: "impôts", logo: "http://lamotheachard.com/wp-content/uploads/2016/08/impots_logo.jpg"}
]

p "creating Sécurité sociale"
my_services += [
  {budgea_name: "Ameli", budgea_id: 50, macro_category: "sécurité_sociale", logo: "http://is3.mzstatic.com/image/thumb/Purple127/v4/64/e1/92/64e1921c-3afe-7d95-5598-8b9e70a7e94d/source/1200x630bb.jpg"},
  {name: "CNMSS", budgea_name: "CNMSS (releves mensuels)", budgea_id: 151, macro_category: "sécurité_sociale", logo: "http://deploiement.cnmss.fr/fileadmin/Images/_logos/logo_illustration_cnmss.jpg"},
  {budgea_name: "Ameli Pro", budgea_id: 51, macro_category: "sécurité_sociale", logo: "http://risquesprofessionnels2016.fr/images/logo.svg"}
]

p "creating Energie"
my_services += [
  {budgea_name: "Direct Energie", budgea_id: "350", macro_category: "énergie", logo: "https://selectra.info/sites/default/files/field/image/direct-energie-xl.png"},
  {budgea_name: "EDF", budgea_id: "52", macro_category: "énergie", logo: "https://upload.wikimedia.org/wikipedia/commons/thumb/1/12/Électricité_de_France_logo.svg/560px-Électricité_de_France_logo.svg.png"},
  {budgea_name: "Engie", budgea_id: "53", macro_category: "énergie", logo: "https://particuliers.engie.fr/etc/designs/particuliers/images/logo-engie.svg"}
]

p "creating Transport"
my_services += [
  {budgea_name: "Autolib.eu", budgea_id: 130, macro_category: "transport", logo: "https://bibliopi.files.wordpress.com/2015/05/autolib-logo-vector-image1.png"},
  {budgea_name: "Uber", budgea_id: 327, macro_category: "transport", logo: "https://botw-pd.s3.amazonaws.com/styles/logo-thumbnail/s3/122013/uber_logo_0.png?itok=nIsy3NXD"},
  {budgea_name: "Chauffeur privé", budgea_id: 733, macro_category: "transport", logo: "https://app.chauffeur-prive.com/images/logotext.svg"},
  {budgea_name: "CityScoot", budgea_id: 150, macro_category: "transport", logo: "https://upload.wikimedia.org/wikipedia/commons/6/6f/Cityscoot_logo.png"}
]

p "creating Emploi"
my_services += [
  {budgea_name: "Pôle emploi", budgea_id: 100, macro_category: "emploi", logo: 'https://upload.wikimedia.org/wikipedia/fr/thumb/c/cd/Logo_P%C3%B4le_Emploi.png/922px-Logo_P%C3%B4le_Emploi.png'}
]

p "creating Poste"
my_services += [
  {name: "La Poste", budgea_name: "La poste (la boutique)", budgea_id: 334, macro_category: "poste", logo: 'https://upload.wikimedia.org/wikipedia/fr/2/2a/Logo-laposte.png'}
]

p "persisiting all services"

i = 1
my_services.each do |s|
  s[:budgea_name] = s[:budgea_name].downcase
  if s[:name].nil?
    s[:name] = s[:budgea_name].titleize
  end
  my_service = Service.new(s)
  cl_response = Cloudinary::Uploader.upload(s[:logo])
  my_service.remote_logo_url = cl_response["secure_url"]
  my_service.save
  Cloudinary::Uploader.destroy(cl_response["public_id"])
  p "#{i} added"
  i += 1
end

p "creating fournisseur tags"
#Fournisseur
fournisseurs_up = my_services.map { |s| s[:name] }

fournisseurs = fournisseurs_up.map { |e| e.downcase.gsub(/\s/, "_") }

fournisseurs.each do |tag|
  Tag.create(name: tag, category: "supplier")
end


