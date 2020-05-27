require "minitest/autorun"
require "minitest/pride"
require "./lib/exhibit"

class ExhibitTest < MiniTest::Test

	def setup
		@exhibit = Exhibit.new({name: "Gems and Minerals", cost: 0})
	end

  def test_it_exists_with_attributes
		assert_instance_of Exhibit, @exhibit
		assert_equal "Gems and Minerals", @exhibit.name
		assert_equal 0, @exhibit.cost
  end

end
