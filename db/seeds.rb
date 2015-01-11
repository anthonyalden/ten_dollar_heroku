# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# items = Item.create([{item_tag: "iPhone 6 Plus Leather Beltclip Case", 
# 					description: "iPhone 6 Plus black case made of fine imported leater.  Comes with belt clip for convenient attachemt you your belt.  ", 
# 					photo: "", 
# 					category: "phone accessories",
# 					search_tags: "phone, case, beltclip",
# 					shipping_cost: 3.00, sold: false},
# 					{item_tag: "Leather Wallet", 
# 					description: "This black leather wallet holds your cash and up to 20 credit cards, driver's license, and other cards.  Made from imported leather, it is constructed to last.", 
# 					photo: "", 
# 					category: "men furnishing",
# 					search_tags: "wallet",
# 					shipping_cost: 2.50, sold: false},
# 					{item_tag: "MagnaLite portable lantern", 
# 					description: "This portable lantern comes complete with 25 bright white LED  lights.  Low power consumption meeans longer battery lifte.  Ideal for camping or for use in an emergency ", 
# 					photo: "", 
# 					category: "camping",
# 					search_tags: "lantern, flashlight, light, lamp",
# 					shipping_cost: 4.99, sold: false}])

sellers = Seller.create([{username: "tjamison@ewhatever.net",
						password: "123456789*&^",
						first_name: "Tom",
						last_name: "Jamison",
						phone: "310-555-1212",
						email: "tjamison@whatever.net"},
						{username: "sampson987",
						password: "123456789*&^",
						first_name: "Kyle",
						last_name: "Franks",
						phone: "310-555-4589",
						email: "kyle89@whatever.net"},
						{username: "Sally@aol.com",
						password: "coast789*&^",
						first_name: "Sally",
						last_name: "Smith",
						phone: "310-555-4312",
						email: "sally@aol.com"}])
