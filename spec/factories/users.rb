FactoryGirl.define do
 sequence :axapta_user_id do |n|
  n
 end

 sequence :word do |n|
  "word#{n}"
 end

 factory :account do
  #user
  #association :user
  axapta_hash { Factory.next(:ext_hash) }
  axapta_user_id
  blocked false
  contact_first_name { Factory.next(:word) }
  contact_middle_name { Factory.next(:word) }
  contact_last_name { Factory.next(:word) }
  after_build {|a| a.axapta_hash = a.user.ext_hash if defined?(a.user.ext_hash) && a.user.ext_hash }
  #after_build {|a| a.axapta_parent_id = a.parent.axapta_user_id if a.parent.try(:axapta_user_id) }
 end

 sequence :manager_name do |n|
  "manager_#{n}"
 end

 factory :manager do
  name { Factory.next :manager_name }
  password "password"
  after_build {|m| m.send(:make_salt) }
 end

 sequence :email do |n|
   "user#{n}@example.com"
 end

 sequence :username do |n|
   "user#{n}"
 end

 sequence :ext_hash do |n|
  Digest::MD5.hexdigest(['axapta', n.to_s].join)
 end

 factory :user do
  email
  password "password"
  username { Factory.next(:username) }
  ext_hash { Factory.next(:ext_hash)  }
  after_build {|m| m.send(:make_salt) }
  after_build {|m| m.encrypt_password }
  after_build {|m| m.send :generate_remember_token }
 end
end

