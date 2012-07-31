require_relative 'model'

products = IO.readlines('products.txt').map { |line| Product.new JSON[line] }
listings = IO.readlines('listings.txt').map { |line| Listing.new JSON[line] }

products.each do |product|

  matched_listings = listings.select { |listing| listing.matches?(product) }
  
  listings = listings - matched_listings

  result = {}
  result['product_name'] = product.to_hash['product_name']
  result['listings'] = matched_listings.map { |listing| listing.to_hash }

  puts result.to_json

end
