FactoryGirl.define do

 sequence :axapta_user_id do |n|
  n
 end

 factory :account do
  #user
  #association :user
  axapta_hash { Factory.next(:ext_hash) }
  axapta_user_id
  after_build {|a| a.axapta_hash = a.user.ext_hash if defined?(a.user.ext_hash) && a.user.ext_hash }
  after_build {|a| a.axapta_parent_id = a.parent.axapta_user_id if a.parent.try(:axapta_user_id) }
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
  username
  ext_hash
  after_build {|m| m.send(:make_salt) }
 end
end

