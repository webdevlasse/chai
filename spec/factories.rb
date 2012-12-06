FactoryGirl.define do
  factory :user1, class: User do
    email_variable = (('a'..'z').to_a + (0..9).to_a).shuffle[0..6].join
    password_variable = url_short = (('a'..'z').to_a + (0..9).to_a).shuffle[0..10].join
    email "#{email_variable}@chai.com"
    password "#{password_variable}"
  end

  factory :user2, class: User do
    email "ferdi@chai.com"
    password "000000"
  end

  factory :shop do
    sequence(:name) { |n| "Shop #{n}" }
    address    "717 California Ave, San Francisco, CA"
    rating     4.5
    yelp_url  "http://www.devbootcamp.com"
    img_url   "http://devbootcamp.com/imgs/teaching-large-sherif.png"
    latitude   37.7896539
    longitude  -122.4019653
    chai_score nil

    factory :shop1, parent: :shop do
      name       "Boot Coffee"
      latitude   37.7896539
      longitude  -122.4019653
    end

    factory :shop2, parent: :shop do
      name       "FlatIron Coffee"
      latitude   17.7896539
      longitude  -122.4019653
    end
  end





  factory :visit1, class: Visit do
    shop
    wifi 2
    power 3
    atmosphere 4
  end

  factory :visit2, class: Visit do
    shop
    wifi 5
    power 7
    atmosphere 8
  end
end
