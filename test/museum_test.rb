require "minitest/autorun"
require "minitest/pride"
require "mocha/minitest"
require "./lib/museum"
require "./lib/patron"
require "./lib/exhibit"

class MuseumTest < MiniTest::Test

	def setup
    @dmns = Museum.new("Denver Museum of Nature and Science")

    @gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
    @dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
    @imax = Exhibit.new({name: "IMAX",cost: 15})

    @patron_1 = Patron.new("Bob", 20)
    @patron_2 = Patron.new("Sally", 20)
    @patron_3 = Patron.new("Johnny", 5)

    @broke_bob = Patron.new("Bob", 0)
	end

  def test_it_exists_with_attributes
    assert_instance_of Museum, @dmns
    assert_equal "Denver Museum of Nature and Science", @dmns.name
    assert_equal [], @dmns.exhibits
    assert_equal [], @dmns.patrons
  end

  def test_it_can_add_exhibits
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    assert_equal [@gems_and_minerals, @dead_sea_scrolls, @imax], @dmns.exhibits
  end

  def test_it_can_recomend_exhibits_to_patrons_interests
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    @patron_1.add_interest("Dead Sea Scrolls")
    @patron_1.add_interest("Gems and Minerals")
    @patron_2.add_interest("IMAX")
    @patron_3.add_interest("Dead Sea Scrolls")

    assert_equal [@gems_and_minerals, @dead_sea_scrolls], @dmns.recommend_exhibits(@patron_1)
    assert_equal [@imax], @dmns.recommend_exhibits(@patron_2)
  end

  def test_it_can_admit_patrons
    assert_empty @dmns.patrons

    @dmns.admit(@patron_1)
    @dmns.admit(@patron_2)
    @dmns.admit(@patron_3)

    assert_equal [@patron_1, @patron_2, @patron_3], @dmns.patrons
  end

  def test_it_can_group_patrons_by_exhibit_interest
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    @patron_1.add_interest("Gems and Minerals")
    @patron_1.add_interest("Dead Sea Scrolls")
    @patron_2.add_interest("Dead Sea Scrolls")
    @patron_3.add_interest("Dead Sea Scrolls")

    @dmns.admit(@patron_1)
    @dmns.admit(@patron_2)
    @dmns.admit(@patron_3)

    expected =
    {
      @gems_and_minerals => [@patron_1],
      @dead_sea_scrolls => [@patron_1, @patron_2, @patron_3],
      @imax => []
    }

    assert_equal expected, @dmns.patrons_by_exhibit_interest
  end

  def test_it_has_a_lottery_for_patrons_without_enough_money
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    @broke_bob.add_interest("Gems and Minerals")
    @broke_bob.add_interest("Dead Sea Scrolls")
    @patron_2.add_interest("Dead Sea Scrolls")
    @patron_3.add_interest("Dead Sea Scrolls")

    @dmns.admit(@broke_bob)
    @dmns.admit(@patron_2)
    @dmns.admit(@patron_3)

    assert_equal [@broke_bob, @patron_3], @dmns.ticket_lottery_contestants(@dead_sea_scrolls)
    assert_equal [], @dmns.ticket_lottery_contestants(@gems_and_minerals)
  end

  def test_it_can_draw_a_lottery_winner
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    @broke_bob.add_interest("Gems and Minerals")
    @broke_bob.add_interest("Dead Sea Scrolls")
    @patron_2.add_interest("Dead Sea Scrolls")
    @patron_3.add_interest("Dead Sea Scrolls")

    @dmns.admit(@broke_bob)
    @dmns.admit(@patron_2)
    @dmns.admit(@patron_3)

    @dmns.expects(:pick_random_winner).returns(@broke_bob)
    expected = "Bob"
    assert_equal expected, @dmns.draw_lottery_winner(@dead_sea_scrolls)
  end

  def test_it_will_return_nil_if_no_contestants_are_eligible_in_the_lottery

    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    @broke_bob.add_interest("Gems and Minerals")
    @broke_bob.add_interest("Dead Sea Scrolls")
    @patron_2.add_interest("Dead Sea Scrolls")
    @patron_3.add_interest("Dead Sea Scrolls")

    @dmns.admit(@broke_bob)
    @dmns.admit(@patron_2)
    @dmns.admit(@patron_3)

    assert_nil @dmns.draw_lottery_winner(@gems_and_minerals)
  end

  def test_it_can_announce_a_winner
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    @broke_bob.add_interest("Gems and Minerals")
    @broke_bob.add_interest("Dead Sea Scrolls")
    @patron_2.add_interest("Dead Sea Scrolls")
    @patron_3.add_interest("Dead Sea Scrolls")

    @dmns.admit(@broke_bob)
    @dmns.admit(@patron_2)
    @dmns.admit(@patron_3)

    expected = "No winners for this lottery"

    @dmns.announce_lottery_winner(@gems_and_minerals)

    @dmns.stubs(:draw_lottery_winner).returns("Bob")

    expected = "Bob has won the IMAX edhibit lottery"

    assert_equal expected, @dmns.announce_lottery_winner(@imax)
  end

end
