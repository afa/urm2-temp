FactoryGirl.define do

 factory :account do
  association :user
  axapta_hash { '1234567890abcdef1234567890abcdef' }
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

