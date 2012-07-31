require 'json'
require 'set'
require 'logger'

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
  attr_accessor :manufacturer
  attr_accessor :log
  
  def initialize(hash)
    @hash = hash
    @log = Logger.new(STDERR)
    @log.level = Logger::WARN
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
    self.manufacturer = hash['manufacturer'].fingerprint if hash['manufacturer']
  end
end

class Listing < HashBasedObject
  def initialize(hash)
    super(hash)
    self.fingerprint = hash['title'].fingerprint
    self.manufacturer = hash['manufacturer'].fingerprint if hash['manufacturer']
  end

  def matches?(product)
    !!(manufacturer_matches?(product) and description_matches?(product))
  end

  def description_matches?(product)
    if log.debug? 
      log.debug("description_match?")
      log.debug("\tself: %s" % self.fingerprint.inspect)
      log.debug("\tproduct: %s" % product.fingerprint.inspect)
    end
    
    return true if product.fingerprint.nil? or self.fingerprint.nil?
    
    product.fingerprint.subset?(self.fingerprint)
  end

  def manufacturer_matches?(product)
    if log.debug? 
      log.debug("manufacturer_match?")
      log.debug("\tself: %s" % self.manufacturer.inspect)
      log.debug("\tproduct: %s" % product.manufacturer.inspect)
    end
    
    return true if product.manufacturer.nil? or self.manufacturer.nil?
    
    product.manufacturer.subset?(self.manufacturer)
  end
end
