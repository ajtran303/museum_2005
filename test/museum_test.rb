require "minitest/autorun"
require "minitest/pride"
require "./lib/museum"

class MuseumTest < MiniTest::Test

	def setup
    @dmns = Museum.new("Denver Museum of Nature and Science")
	end

  def test_it_exists_with_attributes
    assert_instance_of Museum, @dmns
    assert_equal "Denver Museum of Nature and Science", @dmns.name
    assert_equal [], @dmns.exhibits
  end

end
