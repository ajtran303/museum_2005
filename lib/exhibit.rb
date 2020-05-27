class Exhibit
  attr_reader :name, :cost

  def initialize(exhibit_information)
    @name = exhibit_information[:name]
    @cost = exhibit_information[:cost]
  end

end
