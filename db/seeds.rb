# db/seeds.rb
require 'faker'

# Delete all records from each table before seeding
tables = ['customers', 'exercises', 'order_details', 'orders', 'products']
tables.each do |table|
  puts "Deleting all records from #{table}..."
  ActiveRecord::Base.connection.execute("DELETE FROM #{table}")
   puts "Records successfully deleted from #{table}."
end

puts 'Seeding database with Exercises...'

# Difficulty Level 1
Exercise.create(
  title: 'Simple Customer Query',
  description: "Retrieve all customer records from the 'customers' table.",
  query:
    "SELECT *
    FROM customers;",
  difficulty: 1,
  details: {
    tables: ['customers'],
    columns: ['*'],
    keywords: %w[SELECT FROM]
  }
)

Exercise.create(
  title: 'List All Products',
  description: "Retrieve a list of all products from the 'products' table in ascending order by product name.",
  query:
    "SELECT *
    FROM products
    ORDER BY product_name ASC;",
  difficulty: 1,
  details: {
    tables: ['products'],
    columns: ['product_name'],
    keywords: ['SELECT', 'FROM', 'ORDER BY', 'ASC']
  }
)

# Difficulty Level 2
Exercise.create(
  title: 'Order Totals for a Customer',
  description: 'Show the customer name and sum the order total_amount (as total_orders) for a specific customer id = 4.',
  query:
    "SELECT customers.customer_name, SUM(orders.total_amount) AS total_orders
    FROM customers
    LEFT JOIN orders
    ON customers.id = orders.customer_id
    WHERE customers.id = 1
    GROUP BY customers.customer_name;",
  difficulty: 2,
  details: {
    tables: %w[customers orders],
    columns: %w[customers.customer_name orders.total_amount],
    keywords: ['SELECT', 'FROM', 'LEFT JOIN', 'ON', 'WHERE', 'SUM', 'AS', 'GROUP BY']
  }
)

Exercise.create(
  title: 'Product Categories with Average Price',
  description: 'Retrieve a list of product categories along with the average product price (as avg_price) for each category.',
  query:
    "SELECT products.category, AVG(products.price) AS avg_price
    FROM products
    GROUP BY products.category;",
  difficulty: 2,
  details: {
    tables: ['products'],
    columns: %w[products.category products.price],
    keywords: ['SELECT', 'FROM', 'GROUP BY', 'AVG', 'AS']
  }
)

# Difficulty Level 3
Exercise.create(
  title: 'Product Sales by Category',
  description: 'Sum the total order details sales for each product category.',
  query:
    "SELECT products.category, SUM(order_details.quantity * products.price)
    FROM products
    INNER JOIN order_details ON products.id = order_details.product_id
    INNER JOIN orders ON order_details.order_id = orders.id
    GROUP BY products.category;",
  difficulty: 3,
  details: {
    tables: %w[products order_details orders],
    columns: %w[products.category order_details.quantity products.price],
    keywords: ['SELECT', 'FROM', 'INNER JOIN', 'ON', 'GROUP BY', 'SUM']
  }
)

Exercise.create(
  title: 'Customers with Highest Total Orders',
  description: 'List the top 3 customers with the highest order total amounts (as total orders).',
  query:
    "SELECT customers.customer_name, SUM(orders.total_amount) AS total_orders
    FROM customers
    INNER JOIN orders ON customers.id = orders.customer_id
    GROUP BY customers.customer_name
    ORDER BY total_orders DESC
    LIMIT 3;",
  difficulty: 3,
  details: {
    tables: %w[customers orders],
    columns: %w[customers.customer_name orders.total_amount],
    keywords: ['SELECT', 'FROM', 'INNER JOIN', 'ON', 'GROUP BY', 'ORDER BY', 'DESC', 'LIMIT']
  }
)

# Create 20 dummy customers
20.times do
  Customer.create(
    customer_name: Faker::Name.name,
    email: Faker::Internet.email,
    phone_number: Faker::PhoneNumber.phone_number,
    address: Faker::Address.full_address
  )
end

# Create 20 dummy products
20.times do
  Product.create(
    product_name: Faker::Commerce.product_name,
    category: Faker::Commerce.department,
    price: Faker::Commerce.price(range: 10.0..1000.0, as_string: false)
  )
end

# Create 20 dummy orders (associated with random customers)
20.times do
  customer = Customer.all.sample
  Order.create(
    customer_id: customer.id,
    order_date: Faker::Date.between(from: 30.days.ago, to: Date.today),
    total_amount: Faker::Commerce.price(range: 50.0..500.0, as_string: false)
  )
end

# Create 20 dummy order details (associated with random orders and products)
20.times do
  order = Order.all.sample
  product = Product.all.sample
  OrderDetail.create(
    order_id: order.id,
    product_id: product.id,
    quantity: Faker::Number.between(from: 1, to: 5),
    subtotal: (product.price * Faker::Number.between(from: 1, to: 5)).round(2)
  )
end
