class UserSeedJob < ApplicationJob
  queue_as :default

  def perform(user)
    user = User.find(user.id)
    create_user_seed(user)
  end


  private

  def create_user_seed(user)
    # ISSUE --- calling this method doesn't create new images on cloudinary, the files created aim at the same url as the prototypes in seed.
    # hence the need to call update_user_prototypes_job in the end to update in async the remote_photo_url (thus duplicating the images on cl)
    # so that when the documents are destroyed the seed prototypes images are kept on cloudinary
    prototypes = [
      # {name:'carte d\'identité', tags: ['documents_personnels','carte_d\'identité']},
      {name:'facture edf', tags: ['énergie', 'facture', 'edf'], date_tags: ['Jan 2018']},
      # {name:'facture edf', tags: ['énergie', 'facture', 'edf'], date_tags: ['Feb 2018']},
      # {name:'carte grise', tags: ['documents_personnels','carte_grise', 'véhicule']},
      # {name:'permis de conduire', tags: ['documents_personnels','permis_de_conduire']},
      # {name:'fiche de paie', tags: ['emploi', 'fiche_de_paie'], date_tags: ['Feb 2018']},
      {name:'fiche de paie', tags: ['emploi', 'fiche_de_paie'], date_tags: ['Jan 2017']},
      # {name:'facture free', tags: ['facture', 'téléphonie', 'free'], date_tags: ['Feb 2018']},
      # {name:'facture free', tags: ['facture', 'téléphonie', 'free'], date_tags: ['Jan 2017']},
      # {name:'attestation Pôle Emploi', tags: ['emploi', 'pôle_emploi'], date_tags: ['Feb 2018']},
      # {name:'déclaration d\'impôts', tags: ['impôts', 'déclaration'], date_tags: ['Jun 2018']},
      # {name:'rib', tags: ['banque', 'crédit_mutuel']},
      # {name:'attestation d\'assurance', tags: ['maaf', 'assurance', 'attestation']},
      {name:'attestation de sécurité sociale', tags: ['sécurité_sociale','attestation']}
    ]

    prototypes.reverse.each do |d|
      prototype = Document.where(prototype: true).where(user_id: nil).find_by(name: d[:name])
      document = prototype.dup
      document.user = user
      if document.save
        document.update(remote_photo_url: "http://res.cloudinary.com/#{ENV['CLOUDINARY_URL'].match(/@(.*)/)[1]}/#{document.photo.file.identifier}")
        d[:tags].each do |t|
          tag = Tag.find_by(name: t)
          document.add_one_tag_to_document(tag)
        end
        if !d[:date_tags].nil?
          d[:date_tags].each do |t|
            document.check_and_add_tag_to_document(t, true)
          end
        end
      end
    end
    # UpdateUserPrototypesJob.perform_later(user)
  end
end



