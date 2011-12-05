# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :offer_world, :class => Offer::World do
   counts []
   raw_prognosis { Hash.new }
  end
end
