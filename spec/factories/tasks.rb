FactoryGirl.define do
  factory :task do
    association :user
    
    title "MyString"
    deadline "2015-11-24 16:18:18"
    position 1
  end

end
