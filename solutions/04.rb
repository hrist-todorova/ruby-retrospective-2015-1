class Card
  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def rank
    @rank
  end

  def suit
    @suit
  end

  def to_s
    suits = {spades: "Spades", hearts: "Hearts",
            diamonds: "Diamonds", clubs: "Clubs"}
    ranks = {2 => 2, 3 => 3, 4 => 4, 5 => 5, 6 => 6, 7 => 7, 8 => 8, 9 => 9,
            10 => 10, jack: "Jack", queen: "Queen", king: "King", ace: "Ace"}
    "#{ranks[@rank]} of #{suits[@suit]}"
  end

  def ==(other)
    @rank == other.rank and @suit == other.suit
  end

end

class Deck
  include Enumerable

  def initialize(deck = nil)
    @deck = deck
    @ranks = [2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king, :ace]
    @sorted_deck
    if deck == nil
      @deck = []
      for i in 0...@ranks.length
      @deck << Card.new(@ranks[i], :spades) << Card.new(@ranks[i], :hearts)
      @deck << Card.new(@ranks[i], :diamonds) << Card.new(@ranks[i], :clubs)
      end
    end
  end

  def size
    @deck.length
  end

  def draw_top_card
    @deck.shift
  end

  def draw_bottom_card
    @deck.pop
  end

  def top_card
    @deck[0]
  end

  def bottom_card
    @deck[-1]
  end

  def shuffle
    @deck.shuffle!
  end

  def sort
    @sorted_deck = []
    sort_by_suit(:clubs)
    sort_by_suit(:diamonds)
    sort_by_suit(:hearts)
    sort_by_suit(:spades)
    @deck = @sorted_deck.compact!
  end

  def deal
    shuffle
  end

  def to_s
    for i in 0...size
      puts @deck[i].to_s
    end
  end

  private
  def sort_by_suit(suit)
    for j in 0...@ranks.length
      if @deck.include?( Card.new(@ranks[j], suit) )
         @sorted_deck.insert(1, Card.new(@ranks[j], suit))
      end
    end
  end

end

class WarDeck < Deck
  def initialize(deck = nil)
    @ranks = [2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king, :ace]
    @suits = [:spades, :hearts, :diamonds, :clubs]
    if deck == nil
      @deck = []
      for i in 0...@ranks.length
      @deck << Card.new(@ranks[i],@suits[0]) << Card.new(@ranks[i],@suits[1])
      @deck << Card.new(@ranks[i],@suits[2]) << Card.new(@ranks[i],@suits[3])
      end
    else
      @deck = deck
    end
  end

  def each
    for i in 0...size
      yield @deck[i]
    end
  end

  class Hand
    def initialize(hand)
      @data = hand
    end

    def size
      @data.length
    end

    def play_card
      @data.shift
    end

    def allow_face_up?
      @data.length <= 3
    end
  end

  def deal
    shuffle
    hand = []
    26.times do
      if @deck.length != 0
        hand << draw_top_card
      end
    end
    Hand.new(hand)
  end

end

class BeloteDeck < Deck
  def initialize(deck = nil)
    @ranks = [7, 8, 9, :jack, :queen, :king, 10, :ace]
    @suits = [:spades, :hearts, :diamonds, :clubs]
    if deck == nil
      @deck = []
      for i in 0...@ranks.length
      @deck << Card.new(@ranks[i],@suits[0]) << Card.new(@ranks[i],@suits[1])
      @deck << Card.new(@ranks[i],@suits[2]) << Card.new(@ranks[i],@suits[3])
      end
    else
      @deck = deck
    end
  end

  def each
    for i in 0...size
      yield @deck[i]
    end
  end

  class Hand
    def initialize(hand)
      @data = hand
    end

    def size
      @data.length
    end

    def includes(a, b)
      @data.include?(Card.new(a, b))
    end

    def highest_of_suit(suit)
      ranks = [7, 8, 9, :jack, :queen, :king, 10, :ace]
      index = 0
      for i in 0..7
        if includes(ranks[- 1 - i], suit)
          index = @data.index(Card.new(ranks[- 1 - i], suit))
          break
        end
      end
      @data[index]
    end

    def belote?
       (includes(:queen, :spades) and includes(:king, :spades)) or
       (includes(:queen, :hearts) and includes(:king, :hearts)) or
       (includes(:queen, :diamonds) and includes(:king, :diamonds)) or
       (includes(:queen, :clubs) and includes(:king, :clubs))
    end

    def has_tierce?(suit)
      @ranks = [7, 8, 9, :jack, :queen, :king, 10, :ace]
      for i in 0...6
        if includes(@ranks[i], suit) and includes(@ranks[i + 1], suit) and
           includes(@ranks[i + 2], suit)
          return true
        end
      end
      false
    end

    def tierce?
      has_tierce?(:spades) or has_tierce?(:hearts) or
       has_tierce?(:diamonds) or has_tierce?(:clubs)
    end

    def has_quarte?(suit)
       @ranks = [7, 8, 9, :jack, :queen, :king, 10, :ace]
       for i in 0...5
          if includes(@ranks[i], suit) and includes(@ranks[i + 1], suit) and
             includes(@ranks[i + 2], suit) and includes(@ranks[i + 3], suit)
            return true
          end
       end
       false
    end

    def quarte?
      has_quarte?(:spades) or has_quarte?(:hearts) or
       has_quarte?(:diamonds) or has_quarte?(:clubs)
    end

    def has_quint?(suit)
       @ranks = [7, 8, 9, :jack, :queen, :king, 10, :ace]
       for i in 0...4
          if includes(@ranks[i], suit) and includes(@ranks[i + 1], suit) and
             includes(@ranks[i + 2], suit) and includes(@ranks[i + 3], suit) and
             includes(@ranks[i + 4], suit)
            return true
          end
       end
       false
    end

    def quint?
      has_quint?(:spades) or has_quint?(:hearts) or
       has_quint?(:diamonds) or has_quint?(:clubs)
    end

    def carre_of_jacks?
      includes(:jack, :spades) and includes(:jack, :hearts) and
      includes(:jack, :diamonds) and includes(:jack, :clubs)
    end

    def carre_of_nines?
      includes(9, :spades) and includes(9, :hearts) and
      includes(9, :diamonds) and includes(9, :clubs)
    end

    def carre_of_aces?
      includes(:ace, :spades)   and includes(:ace, :hearts) and
      includes(:ace, :diamonds)and includes(:ace, :clubs)
    end

 end

  def deal
    shuffle
    hand = []
    8.times do
      if @deck.length != 0
        hand << draw_top_card
      end
    end
    Hand.new(hand)
  end

end

class SixtySixDeck < Deck
  def initialize(deck = nil)
    @ranks = [9, :jack, :queen, :king, 10, :ace]
    @suits = [:spades, :hearts, :diamonds, :clubs]
    if deck == nil
      @deck = []
      for i in 0...@ranks.length
      @deck << Card.new(@ranks[i],@suits[0]) << Card.new(@ranks[i],@suits[1])
      @deck << Card.new(@ranks[i],@suits[2]) << Card.new(@ranks[i],@suits[3])
      end
    else
      @deck = deck
    end
  end

  def each
    for i in 0...size
      yield @deck[i]
    end
  end

  class Hand
    def initialize(hand)
      @data = hand
    end

    def size
      @data.length
    end

    def twenty?(trump_suit)
      ! forty?(trump_suit) and
       (forty?(:spades) or forty?(:hearts) or
         forty?(:diamonds) or forty?(:clubs))
    end

    def forty?(trump_suit)
      @data.include?(Card.new(:queen, trump_suit)) and
      @data.include?(Card.new(:king, trump_suit))
    end

  end

  def deal
    shuffle
    hand = []
    6.times do
      if @deck.length != 0
        hand << draw_top_card
      end
    end
    Hand.new(hand)
  end

end
