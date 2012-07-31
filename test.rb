# coding: utf-8

require_relative 'model'

puts Listing.new({ 'title' => 'Cybershot' }).match?(Product.new({ 'product_name' => 'Cyber-shot' }))


listing = Listing.new(
  JSON['{"title":"Sony - Cybershot DSC-W310 - Appareil Photo Numérique - 12,1 Mpix - Rose","manufacturer":"Sony","currency":"EUR","price":"118.00"}
'])

product = Product.new(
  JSON['{"product_name":"Sony_Cyber-shot_DSC-W310","manufacturer":"Sony","model":"DSC-W310","family":"Cyber-shot","announced-date":"2010-01-06T19:00:00.000-05:00"}
'])

puts listing.match?(product)