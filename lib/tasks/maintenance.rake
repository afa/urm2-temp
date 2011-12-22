namespace :maintenance do
 namespace :enums do
  desc "renew enums from Axapta"
  task :renew => :environment do
   Enumeration.renew_enums
  end
 end
end
