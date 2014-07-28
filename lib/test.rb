load 'sms.rb'
require 'pry-debugger'

#store = SMS::Store.new({name: "Marshall's", image_url: "/images/ross.jpg", website: "www.ross.com", min_age:25, max_age:65})
#store = store.save!
#
user = SMS::User.new({first_name: "Paul", last_name: 'Dombkowski', password: "12345", birthday: "1/1/13",email: "blah@blah.com", sex: "male", username: "PBD"})
user = user.save!
#
#quality = SMS::Quality.new({name: "cheap"})
#quality=quality.save!
#
#store.add_store_quality({name: "cheap",female: true})
#
qualities = SMS::Quality.available({sex:"male"})
#SMS::Read_CSV.stores("../docs/stores.csv")
#SMS::Read_CSV.store_qualities("../docs/qualities.csv")

#stores = quality.stores("male", 40)
stores = user.stores(["casual", "sporty", "metro", "grunge"], "male", 25)
binding.pry
#session = SMS::Session.create({username: "PBD", password: "12345"})
#result = SMS::Session.validate(session)
#puts result[:user].username
#session = SMS::Session.delete(session)
