class Placing
  attr_accesor :name, :place

  def initialize(params={})

  def mongoize
  	@placing ? {:placing => @placing}
  end

  def self.mongoize(object) 
  case object
    when nil then object.mongoize
    when Hash then object.mongoize
    when Placing then object.mongoize
    end
  end

  def self.demongoize(object)
  case object
    when nil then Placing.new(object[:??], object[:??])
    when Hash then Placing.new(object[:??], object[:??])
    when Placing then Placing.new(object[:??], object[:??])
    end
  end

  def self.evolve(object)
  case object
    when nil then object.mongoize
    when Hash then object.mongoize
    when Placing then object.mongoize
    end
  end

end