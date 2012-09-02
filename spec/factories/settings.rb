# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
 factory :setting do
  trait :named do
   name "nam"
  end
  trait :hashed_ru_value do
   value { {1 => :tst_ru} }
  end
  trait :hashed_value do
   value { {1 => :tst} }
  end
 end
end
