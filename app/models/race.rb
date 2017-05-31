class Race
  include Mongoid::Document
  include Mongoid::Timestamps

  field :n, as: :name, type: String
  field :date, type: Date
  field :loc, as: :location, type: Address
  field :next_bib, type: Integer, default: 0

  embeds_many :events, as: :parent, class_name: "Event", order: [:o.asc]
  has_many :entrants, foreign_key: "race._id", :dependent => :delete, order: [:secs.asc, :bib.asc]

  scope :upcoming, ->{where(:date.gte => Date.today)}
  scope :past, ->{where(:date.lt => Date.today)}

  def next_bib
    self.inc(next_bib: 1)[:next_bib]
  end

  def get_group racer
    if racer && racer.birth_year && racer.gender
    quotient=(date.year-racer.birth_year)/10
    min_age=quotient*10
    max_age=((quotient+1)*10)-1
    gender=racer.gender
    name=min_age >= 60 ? "masters #{gender}" : "#{min_age} to #{max_age} (#{gender})"
    Placing.demongoize(:name=>name)
    end
  end
  
  def create_entrant racer
    new_entrant = Entrant.new
    new_entrant.race = (attributes.symbolize_keys.slice(:_id, :n, :date))
    new_entrant.racer = racer.info.attributes
    new_entrant.group  = get_group racer
    events.each do |event|
      if event 
        new_entrant.send("#{event.name}=", event)
      end
    end
    new_entrant.validate
    if new_entrant.valid?
      new_entrant.bib = next_bib
      new_entrant.save
      return new_entrant
    end
    else !new_entrant.valid?
    return new_entrant   
  end

  def self.upcoming_available_to racer
    
  end

  DEFAULT_EVENTS = { "swim"=>{:order=>0, :name=>"swim", :distance=>1.0, :units=>"miles"}, 
 				             "t1"=> {:order=>1, :name=>"t1"}, 
 				             "bike"=>{:order=>2, :name=>"bike", :distance=>25.0, :units=>"miles"},
   					         "t2"=> {:order=>3, :name=>"t2"},
   					         "run"=> {:order=>4, :name=>"run", :distance=>10.0, :units=>"kilometers"}} 

  DEFAULT_EVENTS.keys.each do |name| 
  	define_method("#{name}") do 
  		event=events.select {|event| name==event.name}.first 
  		event||=events.build(DEFAULT_EVENTS["#{name}"])
  	end
  	["order","distance","units"].each do |prop| 
  		if DEFAULT_EVENTS["#{name}"][prop.to_sym] 
  			define_method("#{name}_#{prop}") do
  			event=self.send("#{name}").send("#{prop}") 
  		end 
  	define_method("#{name}_#{prop}=") do |value| 
  		event=self.send("#{name}").send("#{prop}=", value) 
  	   end 
    end 
    end
  end
 
  def self.default
      Race.new do |race| 
     	DEFAULT_EVENTS.keys.each {|leg|race.send("#{leg}")}
      end
  end
 
  ["city", "state"].each do |action| 
  	define_method("#{action}") do 
  		self.location ? self.location.send("#{action}") : nil 
  	end 
  	define_method("#{action}=") do |name|
  	 object=self.location ||= Address.new
  	 object.send("#{action}=", name)
  	 self.location=object
  	end
  end

end