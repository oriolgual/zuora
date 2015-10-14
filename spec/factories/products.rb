FactoryGirl.define do
  factory :product, :class => Zuora::Objects::Product do
    sequence(:name){|n| "Example Product #{n}"}
    effective_start_date { Date.today }
    effective_end_date { Date.today + 10.days }
  end

  factory :product_catalog, :parent => :product do
    after_create do |product|
      rate_plan = FactoryGirl.create(:product_rate_plan, :product => product)
      FactoryGirl.create(:product_rate_plan_charge, :product_rate_plan => rate_plan)
    end
  end
end
