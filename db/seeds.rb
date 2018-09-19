# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Order.destroy_all

Order.create([{
    bc_order_id: 171,
    store_id: 97,
    sent_to_amazon: true,
    amazon_order_id: 162,
    fulfillable: true
  },
  {
    bc_order_id: 159,
    store_id: 97,
    sent_to_amazon: true,
    amazon_order_id: 159,
    fulfillable: true
  },
  {
    bc_order_id: 156,
    store_id: 97,
    sent_to_amazon: true,
    amazon_order_id: 156,
    fulfillable: true
  },
    {
    bc_order_id: 155,
    store_id: 97,
    sent_to_amazon: true,
    amazon_order_id: 155,
    fulfillable: true
  },
    {
    bc_order_id: 154,
    store_id: 97,
    sent_to_amazon: true,
    amazon_order_id: 154,
    fulfillable: true
  },
    {
    bc_order_id: 153,
    store_id: 97,
    sent_to_amazon: true,
    amazon_order_id: 153,
    fulfillable: true
  },
  {
    bc_order_id: 160,
    store_id: 97,
    sent_to_amazon: true,
    amazon_order_id: 160,
    fulfillable: true
  },  
  {
    bc_order_id: 161,
    store_id: 97,
    sent_to_amazon: true,
    amazon_order_id: 161,
    fulfillable: true
  },
  {
    bc_order_id: 144,
    store_id: 97,
    sent_to_amazon: true,
    amazon_order_id: 144,
    fulfillable: true
  },  
  {
    bc_order_id: 145,
    store_id: 97,
    sent_to_amazon: true,
    amazon_order_id: 145,
    fulfillable: true
  }])

puts "all good"