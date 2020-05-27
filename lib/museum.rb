class Museum
  attr_reader :name, :exhibits, :patrons

  def initialize(name)
    @name = name
    @exhibits = []
    @patrons = []
  end

  def add_exhibit(exhibit)
    @exhibits << exhibit
  end

  def recommend_exhibits(patron)
    @exhibits.filter do |exhibit|
      patron.interests.include?(exhibit.name)
    end
  end

  def admit(patron)
    @patrons << patron
  end

  def patrons_by_exhibit_interest
    patrons_by_exhibit_interest = Hash.new
    @exhibits.each do |exhibit|
      patrons_by_exhibit_interest[exhibit] = []
    end
    @patrons.each do |patron_with_interest|
      exhibits_of_interest = recommend_exhibits(patron_with_interest)
      exhibits_of_interest.each do |exhibit_of_interest|
        patrons_by_exhibit_interest[exhibit_of_interest] << patron_with_interest
      end
    end
    patrons_by_exhibit_interest
  end

  def ticket_lottery_contestants(exhibit)
    candidates = patrons_by_exhibit_interest[exhibit]
    candidates.filter do |candidate|
      candidate.spending_money < exhibit.cost
    end
  end

  def pick_random_winner(candidates)
    candidates.sample
  end

  def draw_lottery_winner(exhibit)
    candidates = ticket_lottery_contestants(exhibit)
    winner = pick_random_winner(candidates)
    if winner == nil
      nil
    else
      winner.name
    end
  end

end
