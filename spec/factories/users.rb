#Factory.sequence :username do |n|
#  "user#{n}"
#end

Factory.define :account do |account|
 account.association :user
 account.axapta_hash { '1234567890abcdef1234567890abcdef' }
end

Factory.sequence :manager_name do |n|
 "manager_#{n}"
end

Factory.define :manager do |man|
 man.name { Factory.next :manager_name }
end
