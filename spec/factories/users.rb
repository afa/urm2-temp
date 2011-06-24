#Factory.sequence :username do |n|
#  "user#{n}"
#end

Factory.define :account do |account|
 account.association :user
 account.axapta_hash { '1234567890abcdef1234567890abcdef' }
end


