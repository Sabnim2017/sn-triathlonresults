class Address
  attr_accessor :city, :state, :location

  def initialize(city,state,location)
    @city = city.nil? ? nil : city
    @state = state.nil? ? nil : state
    @location = location.nil? ? nil : Point.new(location[:coordinates][0],location[:coordinates][1])
  end

  def mongoize
  	!(@city && @state && @location).nil? ? 
                      {:city=> @city, :state=> @state, :loc=>(@location.mongoize)} : nil
  end

  def self.mongoize(object) 
  case object
    when nil then nil
    when Hash then object.mongoize
    when Address then object.mongoize
    end
  end

  def self.demongoize(object)
  case object
    when nil then nil
    when Hash then Address.new(object[:city], object[:state], object[:loc])
    when Address then Address.new(object[:city], object[:state], object[:loc])
    end
  end

  def self.evolve(object)
  case object
    when nil then nil
    when Hash then object.mongoize
    when Address then object.mongoize
    end
  end
end