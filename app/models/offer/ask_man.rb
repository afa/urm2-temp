#require "web_utils"
class Offer::AskMan < Offer::Base
  def self.search(hsh)
   return AxaptaResults.new([], {:type => AxaptaState::WARN, :error => "not found", :message => I18n.t("errors.search.empty")}) if hsh.blank? || ((hsh[:query_string].blank? || hsh[:query_string].size < 3))
   data = AxaptaResults.new([{:name => hsh[:query_string]}], {:type => AxaptaState::OK, :error => nil, :message => nil}).process{|d| fabricate(d) }

# :show_delivery_prognosis => true,
   #TODO: to offers
   #fabricate(data)
  end

  def self.fabricate(arr)
   rez = AxaptaResults.new.from_prepared([], arr)
   arr.each do |hsh|
    rez << self.new do |n|
     n.name = hsh.name
     CartAskMan.prepare_code(n)
    end
   end
   rez
  end


end
