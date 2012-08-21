class Employee < ActionMailer::Base
  default from: "urm2@urm2.rbagroup.ru"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.employee.feedback.subject
  #
  def feedback acc, acc_name, acc_mail, subj, body, attach
    (attach || []).dup.map{|a| a.blank? ? nil : a }.compact.each do |att|
     attachments[att.original_filename] = att.read
    end
    @body = body
    email = Setting.where(:name => "support.source.email").first
    mail :to => acc.contact_email, :from => email, :subject => [t(:urm_email_subj_prefix), subj].join(' '), "Reply-To" => "#{acc_name} <#{acc_mail}>"
  end

  def support acc, acc_name, acc_mail, subj, body, attach
    (attach || []).dup.map{|a| a.blank? ? nil : a }.compact.each do |att|
     attachments[att.original_filename] = att.read
    end
    @body = body
    email = Setting.where(:name => "support.source.email").first
    dest = Setting.where(:name => "support.email").first
    mail :to => dest, :from => email, :subject => [t(:urm_email_subj_prefix), subj].join(' '), "Reply-To" => "#{acc_name} <#{acc_mail}>"
  end
end
