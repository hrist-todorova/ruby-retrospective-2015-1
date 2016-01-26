class Integer
  def prime?
    return false if self == 1
    2.upto(self ** 0.5).all? { |n| self % n != 0 }
  end
end

class RationalSequence
  include Enumerable

  def initialize(limit)
    @limit = limit
  end

  def each
    counter = 0
    row, col = 1, 1
    while counter < @limit
      if row.gcd(col) == 1
        yield Rational(row, col)
        counter += 1
      end
      row, col = calculate_direction(row, col)
    end
  end

  def calculate_direction(row, col)
    if col == 1 and row.odd?
      row += 1
    elsif row == 1 and col.even?
      col += 1
    elsif (row + col).even?
      row += 1
      col -= 1
    else
      row -= 1
      col += 1
    end
      return row, col
  end

end

class PrimeSequence
  include Enumerable

  def initialize(limit)
    @limit = limit
  end

  def each
    stop = 0
    current_number = 2

    while stop < @limit
      if current_number.prime?
        yield current_number
        stop += 1
      end
      current_number += 1
    end
  end

end

class FibonacciSequence
  include Enumerable

  def initialize(limit,first: 1, second: 1)
    @limit = limit
    @first = first
    @second = second
  end

  def each
    return if @limit == 0
    stop = 0

    yield @first
    while stop < @limit - 1
      stop += 1
      yield @second
      @first, @second = @second, @first + @second
    end
  end

end

module DrunkenMathematician
  module_function

  def meaningless(n)
    return 1 if n == 0
    groups = RationalSequence.new(n).partition do |rational|
      rational.numerator.prime? or rational.denominator.prime?
    end

    groups[0].reduce(1, :*) / groups[1].reduce(1, :*)
  end

  def aimless(n)
    return 0 if n == 0
    numbers = PrimeSequence.new(n).each_slice(2).map do |pair|
      pair.length == 2 ? Rational(pair.first, pair.last) :
                         Rational(pair.first, 1)
    end
    numbers.reduce(:+)
  end

  def worthless(n)
    return [] if n == 0
    fibonacci = FibonacciSequence.new(n).to_a.last

    cut = 1
    rationals_cut = RationalSequence.new(cut)
    while rationals_cut.reduce(:+) <= fibonacci
      cut += 1
      rationals_cut = RationalSequence.new(cut)
    end

    RationalSequence.new(cut - 1).to_a
  end

end
