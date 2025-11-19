# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb

# Clear existing products (be careful if you have production data!)
Product.delete_all

# Seed data: 10 sample products
products = [
  {
    title: "Wooden Chair",
    description: "A handcrafted wooden chair made from oak, perfect for dining rooms.",
    image_url: "wooden_chair.png",
    price: 49.99
  },
  {
    title: "Modern Lamp",
    description: "A sleek modern lamp with a metal stand and soft LED light.",
    image_url: "modern_lamp.png",
    price: 29.95
  },
  {
    title: "Coffee Table",
    description: "Stylish coffee table made of walnut with a smooth finish.",
    image_url: "coffee_table.png",
    price: 89.50
  },
  {
    title: "Leather Wallet",
    description: "Premium quality leather wallet with multiple card slots.",
    image_url: "leather_wallet.png",
    price: 19.99
  },
  {
    title: "Bluetooth Speaker",
    description: "Portable Bluetooth speaker with high-fidelity sound and long battery life.",
    image_url: "bluetooth_speaker.png",
    price: 59.99
  }
]

products.each do |attrs|
  Product.create!(attrs)
end

puts "Seeded #{Product.count} products."
