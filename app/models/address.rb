class Address
  attr_accessor :city, :state, :location

  def initialize(city=nil,state=nil,location)
    @city = city
    @state = state
    @location = location.nil? ? nil : Point.new(location[:coordinates][0],location[:coordinates][1])
  end

  def mongoize
    hash = Hash.new
    hash[:city] = @city if @city
    hash[:state] = @state if @state
    hash[:loc] = Point.mongoize(@location) 
    return hash
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
    when Address then object
    else
      object
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