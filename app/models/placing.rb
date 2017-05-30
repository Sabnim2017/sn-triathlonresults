class Placing
  attr_accessor :name, :place

  def initialize(name, place)
    @name = name.nil? ? nil  : name
    @place = place.nil? ? nil : place
  end

  def mongoize
  	!(@name || @place).nil? ? {:name => @name, :place => @place} : nil
  end

  def self.mongoize(object) 
  case object
    when nil then nil
    when Hash then object.mongoize
    when Placing then object.mongoize
    end
  end

  def self.demongoize(object)
  case object
    when nil then nil
    when Hash then Placing.new(object[:name], object[:place])
    when Placing then Placing.new(object[:name], object[:place])
    end
  end

  def self.evolve(object)
  case object
    when nil then nil
    when Hash then object.mongoize
    when Placing then object.mongoize
    end
  end

end