require 'json'
require 'set'

# system level
module NLP
  def fingerprint
    self.downcase.split(/[_\- ]/).to_set
  end
end

class String
  include NLP
end

class HashBasedObject
  attr_accessor :fingerprint
  
  def initialize(hash)
    @hash = hash
  end

  def to_hash
    @hash 
  end
end

# application level
class Product < HashBasedObject
  def initialize(hash)
    super(hash)
    self.fingerprint = hash['product_name'].fingerprint
  end
end

class Listing < HashBasedObject
  def initialize(hash)
    super(hash)
    self.fingerprint = hash['title'].fingerprint
  end
end

# main

products = IO.readlines('products.txt').map { |line| Product.new JSON[line] }
listings = IO.readlines('listings.txt').map { |line| Listing.new JSON[line] }

product_tokens = products.inject(Set.new) { |sum, product| sum.merge product.fingerprint }
listing_tokens = listings.inject(Set.new) { |sum, listing| sum.merge listing.fingerprint }

tokens_unique_to_product = product_tokens - listing_tokens

products.each do |product|

  matched_listings = listings.select do |listing|
    the_product_has_been_fully_described   = (product.fingerprint - listing.fingerprint).size == 0
    the_listing_has_nothing_important_left = (tokens_unique_to_product & (listing.fingerprint - product.fingerprint)).size == 0

    # condition of match
    the_product_has_been_fully_described and the_listing_has_nothing_important_left
  end
  
  listings = listings - matched_listings

  result = {}
  result['product_name'] = product.to_hash['product_name']
  result['listings'] = matched_listings.map { |listing| listing.to_hash }

  puts result.to_json

end
