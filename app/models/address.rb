class Address
  attr_accessor :city, :state, :location

  def initialize(params={})
  end

  def mongoize
  	@address ? {:address => @address}
  end

  def self.mongoize(object) 
  case object
    when nil then object.mongoize
    when Hash then object.mongoize
    when Address then object.mongoize
    end
  end

  def self.demongoize(object)
  case object
    when nil then Address.new(object[:??], object[:??])
    when Hash then Address.new(object[:??], object[:??])
    when Address then Address.new(object[:??], object[:??])
    end
  end

  def self.evolve(object)
  case object
    when nil then object.mongoize
    when Hash then object.mongoize
    when Address then object.mongoize
    end
  end
end