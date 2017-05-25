class Point
  attr_accessor :longitude, :latitude

  def initialize(longitude,latitude)
    @longitude = longitude.nil? ? nil : longitude
    @latitude = latitude.nil? ? nil : latitude
  end
  
  def mongoize
  	!(@longitude && @latitude).nil? ? 
                    {:type => "Point", :coordinates => [@longitude, @latitude]} : nil
  end

  def self.mongoize(object) 
  case object
    when nil then nil
    when Hash then object.mongoize
    when Point then object.mongoize
    end
  end

  def self.demongoize(object)
  case object
    when nil then nil
    when Hash then Point.new(object[:coordinates][0], object[:coordinates][1])
    when Point then Point.new(object[:coordinates][0], object[:coordinates][1])
    end
  end

  def self.evolve(object)
  case object
    when nil then nil
    when Hash then object.mongoize
    when Point then object.mongoize
    end
  end

end