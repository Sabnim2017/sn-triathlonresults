class Event
  include Mongoid::Document

  embedded_in :parent, class_name: "Race", polymorphic: true, touch: true 

  field :o, as: :order, type: Integer
  field :n, as: :name, type: String
  field :d, as: :distance, type: Float
  field :u, as: :units, type: String

  validates_presence_of :order
  validates_presence_of :name

  def meters
  	case !distance.nil?
  	when units=="miles" then distance*1609.344
    when units=="meters" then distance
    when units=="kilometers" then distance*1000
    when units=="yards" then distance*0.9144
    else
    	nil
    end
  end

  def miles
  	case !distance.nil?
  	when units=="miles" then distance
    when units=="meters" then distance*0.000621371
    when units=="kilometers" then distance*0.621371
    when units=="yards" then distance*0.000568182 
    else
    	nil
    end
  end

end
