Factory.sequence :email do |n|
  "user#{n}@example.com"
end

Factory.sequence :username do |n|
  "user#{n}"
end

Factory.define :user do |user|
  user.email    { Factory.next :email }
  user.password { "password" }
  user.username { Factory.next :username }
end

Factory.define :email_confirmed_user, :parent => :user do |user|
  user.after_build { warn "[DEPRECATION] The :email_confirmed_user factory is deprecated, please use the :user factory instead." }
end
