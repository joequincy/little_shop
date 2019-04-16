require 'factory_bot_rails'

@time_rng = Random.new(104771926725897930682341174863059830501)
def rand_time(from: 0.0, to: Time.now)
  Time.at(@time_rng.rand(from..to))
end

def order_stats(items, created_at, updated_at)
  item = items.sample
  items.delete(item)
  updated = rand_time(from: created_at, to: updated_at)
  return item, items, updated
end

include FactoryBot::Syntax::Methods

OrderItem.destroy_all
Order.destroy_all
Item.destroy_all
User.destroy_all

site_launched = rand_time(from: 3.years.ago, to: 2.years.ago)

admin = create(:admin)
users = create_list(:user, 20)
merchants = create_list(:merchant, 8)

inactive_merchant_1 = create(:inactive_merchant)
inactive_user_1 = create(:inactive_user)

items = []
(1..160).each do |i|
  items << create(:item, user: merchants.sample, created_at: site_launched, updated_at: site_launched)
end

inactive_item_1 = create(:inactive_item, user: merchants[0])
inactive_item_2 = create(:inactive_item, user: inactive_merchant_1)

Random.new_seed
rng = Random.new

(1..100).each do |i|
  created_at = rand_time(from: 2.years.ago)
  updated_at = rand_time(from: created_at)
  order = create(:shipped_order, user: users.sample, created_at: created_at, updated_at: updated_at)
  potential_items = items.dup
  (1..rng.rand(6)).each do |j|
    item, potential_items, updated_at = order_stats(potential_items, created_at, updated_at)
    create(:fulfilled_order_item, order: order, item: item, price: rng.rand(1..20), quantity: rng.rand(1..5), created_at: created_at, updated_at: updated_at)
  end
end

(1..10).each do |i|
  created_at = rand_time(from: 2.years.ago)
  updated_at = rand_time(from: created_at)
  order = create(:order, user: users.sample, created_at: created_at, updated_at: updated_at)
  potential_items = items.dup
  (1..rng.rand(6)).each do |j|
    item, potential_items, updated_at = order_stats(potential_items, created_at, updated_at)
    item_status = [:fulfilled_order_item, :order_item][rng.rand(0..1)]
    create(:fulfilled_order_item, order: order, item: item, price: rng.rand(1..20), quantity: rng.rand(1..5), created_at: created_at, updated_at: updated_at)
  end
end

(1..40).each do |i|
  created_at = rand_time(from: 2.years.ago)
  updated_at = rand_time(from: created_at)
  order = create(:cancelled_order, user: users.sample, created_at: created_at, updated_at: updated_at)
  potential_items = items.dup
  (1..rng.rand(6)).each do |j|
    item, potential_items, updated_at = order_stats(potential_items, created_at, updated_at)
    create(:order_item, order: order, item: item, price: rng.rand(1..20), quantity: rng.rand(1..5), created_at: created_at, updated_at: updated_at)
  end
end


puts 'seed data finished'
puts "Users created: #{User.count.to_i}"
puts "Orders created: #{Order.count.to_i}"
puts "Items created: #{Item.count.to_i}"
puts "OrderItems created: #{OrderItem.count.to_i}"
