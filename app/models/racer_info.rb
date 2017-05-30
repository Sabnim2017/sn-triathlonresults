class RacerInfo
  include Mongoid::Document

  embedded_in :parent, class_name: "Racer", polymorphic: true

  field :_id, default: -> {racer_id}
  field :racer_id, as: :_id
  field :fn, as: :first_name, type: String
  field :ln, as: :last_name, type: String
  field :g, as: :gender, type: String
  field :yr, as: :birth_year, type: Integer
  field :res, as: :residence, type: Address

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :gender
  validates_presence_of :birth_year
  validates_inclusion_of :gender, in: ["M", "F"]
  validates_numericality_of :birth_year, less_than: Date.today.year.to_i


  ["city", "state"].each do |action| 
    define_method("#{action}") do
      self.residence ? self.residence.send("#{action}") : nil
      end
    define_method("#{action}=") do |name|
      object=self.residence ||= Address.new
      object.send("#{action}=", name)
      self.residence=object
    end
  end

end
