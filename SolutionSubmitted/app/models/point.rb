class Point
  attr_accessor :longitude, :latitude

  def initialize(longitude,latitude)
    @longitude = longitude.nil? ? nil : longitude
    @latitude = latitude.nil? ? nil : latitude
  end
  
  def mongoize
    if @longitude&&@latitude
      {:type=>"Point", :coordinates=>[@longitude, @latitude]} 
    end
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
    when Point then object
    else
      object
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