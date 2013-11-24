# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :work do
    weshi_user_id "MyString"
    work_links "MyString"
    status "MyString"
    remark "MyText"
    category_id 1
    user_id 1
    last_check_user_id 1
  end
end
