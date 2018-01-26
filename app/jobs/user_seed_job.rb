class UserSeedJob < ApplicationJob
  queue_as :default

  def perform(user)
    user = User.find(user.id)
    create_user_seed(user)
  end


  private

  def create_user_seed(user)
    prototypes = [
      {name:'carte d\'identité', tags: ['documents_personnels','carte_d\'identité']},
      {name:'facture edf', tags: ['électricité', 'facture', 'edf'], date_tags: ['Jan 2018']},
      {name:'facture edf', tags: ['électricité', 'facture', 'edf'], date_tags: ['Feb 2018']},
      {name:'facture edf', tags: ['électricité', 'facture', 'edf'], date_tags: ['Oct 2017']},
      {name:'carte grise', tags: ['documents_personnels','carte_grise', 'véhicule']},
      {name:'permis de conduire', tags: ['documents_personnels','permis_de_conduire']},
      {name:'fiche de paie', tags: ['emploi', 'fiche_de_paie'], date_tags: ['Feb 2018']},
      {name:'fiche de paie', tags: ['emploi', 'fiche_de_paie'], date_tags: ['Nov 2017']},
      {name:'fiche de paie', tags: ['emploi', 'fiche_de_paie'], date_tags: ['Dec 2017']},
      {name:'fiche de paie', tags: ['emploi', 'fiche_de_paie'], date_tags: ['Jan 2017']},
      {name:'facture free', tags: ['facture', 'téléphonie', 'free'], date_tags: ['Feb 2018']},
      {name:'facture free', tags: ['facture', 'téléphonie', 'free'], date_tags: ['Nov 2017']},
      {name:'facture free', tags: ['facture', 'téléphonie', 'free'], date_tags: ['Dec 2017']},
      {name:'facture free', tags: ['facture', 'téléphonie', 'free'], date_tags: ['Jan 2017']},
      {name:'attestation Pôle Emploi', tags: ['emploi', 'pôle_emploi'], date_tags: ['Jan 2018']},
      {name:'attestation Pôle Emploi', tags: ['emploi', 'pôle_emploi'], date_tags: ['Feb 2018']},
      {name:'déclaration d\'impôts', tags: ['impôts', 'déclaration'], date_tags: ['Jun 2018']},
      {name:'rib', tags: ['banque', 'crédit_mutuel']},
      {name:'attestation d\'assurance', tags: ['mma', 'assurance', 'attestation']},
      {name:'attestation de sécurité sociale', tags: ['sécurité_sociale','attestation']}
    ]

    prototypes.reverse.each do |d|
      prototype = Document.where(prototype: true).find_by(name: d[:name])
      document = prototype.dup
      document.user = user
      if document.save
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
  end
end


