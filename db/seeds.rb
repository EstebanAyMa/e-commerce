# --- Users ----
User.create!(first_name: "Esteban",
             last_name:  "Ayala",
             email: "esteban.ayala@empresa.com.mx",
             password:              "test1234",
             password_confirmation: "test1234",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

 User.create!(first_name: "Test",
              last_name:  "User",
              email: "test.user@empresa.com.mx",
              password:              "test1234",
              password_confirmation: "test1234",
              activated: true,
              activated_at: Time.zone.now)

# ----- PRODUCTS -----

# Categories
categories = %w[bebidas higiene snacks alimentos otros]
categories.each do |cat_name|
  Category.create!(name: cat_name)
end

# sub-categories for bebidas
category = Category.find(1)
sub_categories = %w[coca pepsi fanta squirt delaware]
sub_categories.each do |sub_cat|
  category.sub_categories.create!(name: sub_cat)
end

# Add first category images
test_img_path = File.open(File.join(Rails.root, '/app/assets/images/refrescos.jpg'))
sub_cats = SubCategory.where(category: category)
sub_cats.each do |sub_cat|
  10.times do |n|
    category.products.create!(sub_category: sub_cat,
                              name: "#{sub_cat.name.capitalize} #{n + 1}",
                              description: Faker::Lorem.sentence(rand(20..60)),
                              price: rand(1..3.5).round(2),
                              quantity: rand(5..20),
                              primary_img: test_img_path)
  end
end

# Sub-categories for higiene
category = Category.find(2)
sub_categories = %w[desodorante gel shampoo]
sub_categories.each { |sub_cat| category.sub_categories.create!(name: sub_cat) }

# Add second category images
test_img_path = File.open(File.join(Rails.root, '/app/assets/images/higienePersonal.png'))
sub_cats = SubCategory.where(category: category)
sub_cats.each do |sub_cat|
  10.times do |n|
    category.products.create! sub_category: sub_cat,
                              name: "#{sub_cat.name.capitalize} #{n + 1}",
                              description: Faker::Lorem.sentence(rand(20..60)),
                              price: rand(1..3.5).round(2),
                              quantity: rand(5..20),
                              primary_img: test_img_path
  end
end

# Sub-categories for snacks
category = Category.find(3)
sub_categories = %w[galletas papas dulces]
sub_categories.each { |sub_cat| category.sub_categories.create!(name: sub_cat) }

# Add third category images
test_img_path = File.open(File.join(Rails.root, '/app/assets/images/snacks.jpg'))
sub_cats = SubCategory.where(category: category)
sub_cats.each do |sub_cat|
  10.times do |n|
    category.products.create! sub_category: sub_cat,
                              name: "#{sub_cat.name.capitalize} #{n + 1}",
                              description: Faker::Lorem.sentence(rand(20..60)),
                              price: rand(1..3.5).round(2),
                              quantity: rand(5..20),
                              primary_img: test_img_path
  end
end

# Sub-categories for alimentos
category = Category.find(4)
sub_categories = %w[carne pollo pescado]
sub_categories.each { |sub_cat| category.sub_categories.create!(name: sub_cat) }

# Add fourth category images
test_img_path = File.open(File.join(Rails.root, '/app/assets/images/alimentos.jpeg'))
sub_cats = SubCategory.where(category: category)
sub_cats.each do |sub_cat|
  10.times do |n|
    category.products.create! sub_category: sub_cat,
                              name: "#{sub_cat.name.capitalize} #{n + 1}",
                              description: Faker::Lorem.sentence(rand(20..60)),
                              price: rand(1..3.5).round(2),
                              quantity: rand(5..20),
                              primary_img: test_img_path
  end
end

# Sub-categories for otros
category = Category.find(5)
sub_categories = %w[juguetes bicicletas pescado]
sub_categories.each { |sub_cat| category.sub_categories.create!(name: sub_cat) }

# Add third category images
test_img_path = File.open(File.join(Rails.root, '/app/assets/images/otros.jpg'))
sub_cats = SubCategory.where(category: category)
sub_cats.each do |sub_cat|
  10.times do |n|
    category.products.create! sub_category: sub_cat,
                              name: "#{sub_cat.name.capitalize} #{n + 1}",
                              description: Faker::Lorem.sentence(rand(20..60)),
                              price: rand(1..3.5).round(2),
                              quantity: rand(5..20),
                              primary_img: test_img_path
  end
end

# --- Shopping Bags ---
2.times { |n| ShoppingBag.create(user_id: User.last.id) }

# ---- Adresses ----
Address.create! user: User.first, line_1: "Calle #123", town: "CDMX", county: "MX", postcode: "04321"
Address.create! user: User.first, line_1: "Calle #4321", town: "CDMX", county: "MX", postcode: "01234"

# --- Orders ---
def add_order_items(order)
  item_total = 0
  rand(1..5).times do
    item = order.order_items.create!(product_id: rand(1..Product.count), quantity: rand(1..4))
    item_total += item.product.price * item.quantity
  end
  order.update(item_total: item_total, postage: 500)
end

2.times do |n|
  order = Order.create!(user: User.first, status: 1, shipping_address_id: 1, billing_address_id: 1)
  add_order_items(order)
end

3.times do |n|
  order = Order.create!(user: User.first, status: 3, shipping_address_id: 2, billing_address_id: 2, created_at: Time.zone.yesterday)
  add_order_items(order)
end

3.times do |n|
  order = Order.create!(user: User.last, status: 3, shipping_address_id: 1, billing_address_id: 1, created_at: 3.days.ago,)
  add_order_items(order)
end
