class RacerInfo
  include Mongoid::Document
  field :_id, default: -> {racer_id}
  field :racer_id, as: :_id
  field :fn, as: :first_name, type: String
  field :ln, as: :last_name, type: String
  field :g, as: :gender, type: String
  field :yr, as: :birth_year, type: Integer
  field :residence, as: :res, type: Address
end