p "destroy users, tags, documents"
User.destroy_all
Document.destroy_all
Tag.destroy_all
Doctag.destroy_all

p "creating the current_user"

myuser = User.new(email: "test@mail.com",  password: "123456" )
myuser.remote_photo_url = "http://www.annonceschatons.fr/wp-content/uploads/2017/07/il_existe_d__sormais_un_parfum_qui_sent_la_fourrure_de_chaton_28.jpeg_north_1200x_white.jpg"
myuser.save

p "creating tag table"

Tag.create(name: "rib")
Tag.create(name: "facture")
Tag.create(name: "electricité")
Tag.create(name: "scolarité")
Tag.create(name: "banque")
Tag.create(name: "2017")
Tag.create(name: "credit mutuel")


p "Creating documents"

image =[]
image << "app/assets/images/doctest/Certificat-de-scolarite.pdf"
image << "app/assets/images/doctest/RIB.pdf"
image << "app/assets/images/doctest/facture_directenergy_HG.pdf"

tags = [["scolarité", "2017"], ["rib", "banque", "2017", "credit mutuel"], ["facture", "electricité", "2017"]]

3.times do |i|
  mydoc = Document.new(name: image[i - 1])
  mydoc.remote_photo_url = image[i - 1]
  mydoc.user = myuser
  mydoc.save

  tags[i - 1].each do |atag|
    d1 = Doctag.new
    d1.document = mydoc
    d1.tag = Tag.find_by_name(atag)
    d1.save
  end
end



