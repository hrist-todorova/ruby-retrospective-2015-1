class Card

  attr_accessor :rank, :suit

  def initialize(rank, suit)
    @rank, @suit = rank, suit
  end

  def rank
    @rank
  end

  def to_s
    @rank.to_s.capitalize + " of " + @suit.to_s.capitalize
  end

  def ==(other)
    @rank == other.rank and @suit == other.suit
  end

end

class Deck
  include Enumerable

  def initialize(cards = nil)
    @ranks = [:ace, :king, :queen, :jack, 10, 9, 8, 7, 6, 5, 4, 3, 2]
    @suits = [:spades, :hearts, :diamonds, :clubs]

    if cards == nil
      @cards = generate_deck
    else
      @cards = cards.dup
    end

  end

  def each
    @cards.each { |card| yield card }
  end

  def generate_deck
    product = @ranks.product @suits
    product.map { |card| Card.new *card }
  end

  def size
    self.to_a.size
  end

  def draw_top_card
    @cards.shift
  end

  def draw_bottom_card
    @cards.pop
  end

  def top_card
    @cards.first
  end

  def bottom_card
    @cards.last
  end

  def shuffle
    @cards.shuffle!
  end

  def sort
    @cards.sort_by! { |card| [@suits.index(card.suit),
                              @ranks.index(card.rank)] }
  end

  def deal
    shuffle
  end

  def to_s
    @cards.map(&:to_s).join("\n")
  end

  class Hand

      def initialize(cards)
        @cards = cards.dup
      end

      def size
        @cards.size
      end

  end

end

class WarDeck < Deck

  def initialize(cards = nil)
    @hand_size = 26
    super cards
  end

  def deal
    hand = WarHand.new @cards[0...@hand_size]
    @cards = @cards.drop(@hand_size)
    hand
  end

  class WarHand < Hand

    def initialize(cards)
      super
    end

    def play_card
      @cards.shift
    end

    def allow_face_up?
      @cards.size <= 3
    end

  end

end

class BeloteDeck < Deck

  attr_reader :ranks

  def initialize(cards = nil)
    @hand_size = 8
    @ranks = [:ace, :king, :queen, :jack, 10, 9, 8, 7]
    @suits = [:spades, :hearts, :diamonds, :clubs]

    if cards == nil
      @cards = generate_deck
    else
      @cards = cards.dup
    end
  end

  def deal
    hand = BeloteHand.new @cards[0...@hand_size]
    @cards = @cards.drop @hand_size
    hand
  end

  class BeloteHand < Hand

    def initialize(cards)
      super
    end

    def highest_of_suit(suit)
      deck = BeloteDeck.new @cards.select { |card| card.suit == suit }
      deck.sort
      deck.top_card
    end

    def belote?
      @cards.select { |card| card.rank == :king or card.rank == :queen }
      .group_by { |card| card.suit }
      .any? { |_, same_suit| same_suit.size == 2 }
    end

    def tierce?
      check_for_consecutive?(3)
    end

    def quarte?
      check_for_consecutive?(4)
    end

    def quint?
      check_for_consecutive?(5)
    end

    def carre_of_jacks?
      carre?(:jack)
    end

    def carre_of_nines?
      carre?(9)
    end

    def carre_of_aces?
      carre?(:ace)
    end

    private

    def carre?(rank)
      @cards.count { |card| card.rank == rank } == 4
    end

    def check_for_consecutive?(n)
      groups = @cards.group_by { |card| card.suit }
      check = groups.map { |g| consecutive? g[1], n }
      check.any? { |predicate| predicate == true }
    end

    def consecutive?(cards, count)
      cards = cards.map { |c| BeloteDeck.new.ranks.find_index(c.rank) }.sort
      last = cards[0]
      groups = cards.slice_before do |e|
        last, prev = e, last
        prev + 1 != e
      end
      groups.to_a.any? { |group| group.size > 2 }
    end

  end

end

class SixtySixDeck < Deck

  def initialize(cards = nil)
    @hand_size = 6
    @ranks = [:ace, :king, :queen, :jack, 10, 9]
    @suits = [:spades, :hearts, :diamonds, :clubs]

    if cards == nil
      @cards = generate_deck
    else
      @cards = cards
    end
  end

  def deal
    hand = SixtySixHand.new @cards[0...@hand_size]
    @cards = @cards.drop @hand_size
    hand
  end

  class SixtySixHand < Hand

    def initialize(cards)
      super
    end

    def twenty?(trump_suit)
      not forty?(trump_suit) and ((forty?(:spades) or forty?(:hearts) or
          forty?(:diamonds) or forty?(:clubs)))
    end

    def forty?(trump_suit)
      @cards.include?(Card.new(:queen, trump_suit)) and
      @cards.include?(Card.new(:king, trump_suit))
    end

  end

end



