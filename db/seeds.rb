
description = "Never in all their history have men been able truly to conceive of the world as one: a single sphere, a globe, having the qualities of a globe, a round earth in which all the directions eventually meet, in which there is no center because every point, or none, is center — an equal earth which all men occupy as equals. The airman's earth, if free men make it, will be truly round: a globe in practice, not in theory.

The dreams of yesterday are the hopes of today and the reality of tomorrow.

Astronomy compels the soul to look upward, and leads us from this world to another.

What was most significant about the lunar voyage was not that man set foot on the Moon but that they set eye on the earth.

When I orbited the Earth in a spaceship, I saw for the first time how beautiful our planet is. Mankind, let us preserve and increase this beauty, and not destroy it!"

User.create!(
  email:                 'codyeatworld@ctrlalt.io', 
  username:              'codyeatworld', 
  password:              'password', 
  password_confirmation: 'password',
  admin:                 true
)

GroupBuy.create!([
  {
    name: 'JTK Sophomore', 
    slug: 'jtk-sophomore', 
    user_id: 1, 
    content: description,
    remote_image_url: 'https://d1aoqdsbsuo9t3.cloudfront.net/uploads/group_buy/banner/17/772270289f3d4737ced81eaedd3176e8.png',
    deadline: Time.zone.now+50.days,
    shipping_eta: Time.zone.now+55.days
  }, {
    name: 'Hyper Fuse GMK', 
    slug: 'hyper-fuse-gmk', 
    user_id: 1, 
    content: description,
    remote_image_url: 'https://d1aoqdsbsuo9t3.cloudfront.net/uploads/group_buy/banner/14/d9b3e55f4122faa8510009d82693dcef.png',
    deadline: Time.zone.now-100.days,
    shipping_eta: Time.zone.now-95.days
  },
  {name: "Store", slug: "store", visible: false, active: false, shipping_eta: Time.zone.now+300.days, deadline: "2013-06-15 21:45:00", created_at: "2013-11-15 21:45:38", updated_at: "2014-03-20 13:12:54"},

])

Product.create!([
  {
    name: 'Purple & White', 
    slug: 'purple-white',
    group_buy_id: 1,
    remote_image_url: 'https://d1aoqdsbsuo9t3.cloudfront.net/uploads/item/default_image/101/7df3d8da9e4d4fdd90e143e5b19954dc.png'
  }, {
    name: 'Deluxe', 
    slug: 'deluxe',
    group_buy_id: 2,
    remote_image_url: 'https://d1aoqdsbsuo9t3.cloudfront.net/uploads/item/default_image/89/84b643fcb69d8bb7369fdc5d926ef432.png'
  }
])

Variant.create!([{
    name: 'Purple & White', 
    product_id: 1, 
    unit_price: 58.00, 
    weight: 14,
    stock: 8,
    limit: 3
  }, {
    name: 'w/ 104 MX to Topre Sliders', 
    product_id: 1, 
    unit_price: 73.00, 
    weight: 18,
    stock: 15,
    limit: 12
  }, {
    name: 'Deluxe', 
    product_id: 2, 
    unit_price: 115.00, 
    weight: 16,
    stock: 5,
    limit: 5
  }
])