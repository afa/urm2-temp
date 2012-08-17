class Employee < ActionMailer::Base
  default from: "urm2@urm2.rbagroup.ru"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.employee.feedback.subject
  #
  def feedback acc, subj, body, attach
    @greeting = "Hi"
    (attach || []).dup.map{|a| a.blank? ? nil : a }.compact.each do |att|
     attachments[att.original_filename] = att.read
    end
    mail :to => acc.empl_email, :from => acc.contact_email, :subj => subj 
  end
end
