namespace :maintenance do
 namespace :enums do
  desc "renew enums from Axapta"
  task :renew => :environment do
   Setting.find_or_create_by_name("hash.quotation_status_rus").update_attributes :value => AxaptaRequest.describe_methods["enums"]["quotation_status_rus"].to_yaml
   Setting.find_or_create_by_name("hash.quotation_status").update_attributes :value => AxaptaRequest.describe_methods["enums"]["quotation_status"].to_yaml
  end
 end
end
