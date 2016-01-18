class RationalSequence
  include Enumerable

  def initialize(limit)
    @limit = limit - 1
    @saver = limit
    @arr = []
    @step = 2
  end

  def to_a
    if @limit == - 1 then return @arr else @arr.push(Rational(1,1)) end
    while(@limit > 0)
      i = 1
      while(@limit > 0 and i <= @step)
        @arr.push(Rational(@step - i + 1, i)).uniq!
        @limit = @saver - @arr.length
        i += 1
      end
      @step += 1
      i = 1
      while(@limit > 0 and i <= @step)
        @arr.push(Rational(i, @step - i + 1)).uniq!
        @limit = @saver - @arr.length
        i += 1
      end
      @step += 1
    end
    @arr
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

    while stop < @limit do
      if prime?(current_number)
        yield current_number
        stop = stop+1
       end
       current_number = current_number + 1
    end
  end


  def prime?(n)
    return false if n <= 1
    2.upto(n-1) do |x|
      return false if n%x == 0
                   end
      true
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
    if(@limit == 0)
    yield
    return
    end
    stop = 0

    yield @first
    while stop < @limit-1
      stop = stop + 1
      yield @second
      @first, @second = @second, @first + @second
    end
  end

end


module DrunkenMathematician
  module_function

  def meaningless(n)
    if (n == 0)
      return 0
    end
    arr = RationalSequence.new(n).to_a
    first_array = []
    second_array = []
    for i in 0...n
      if !PrimeSequence.new(1).prime?(arr[i].numerator) and
         !PrimeSequence.new(1).prime?(arr[i].denominator)
        second_array << arr[i]
      else
        first_array << arr[i]
      end
    end
    product_one = 1
    first_array.each { |a| product_one *= a }
    product_two = 1
    second_array.each { |a| product_two *= a }
    product_one / product_two
  end

  def aimless(n)
    if (n == 0)
      return 0
    end
    sum = 0
    arr = PrimeSequence.new(n).to_a
    (0..n/2).each do |i|
        if i%2 == 0
        sum = sum + Rational(arr[i],arr[i+1])
        end
    end
    sum
  end

  def worthless(n)
    if (n == 0)
      0
    else
      number = FibonacciSequence.new(n).to_a.at(n-1)
      i = 1
      sum = RationalSequence.new(i).to_a.reduce :+
      while sum.ceil <= number
       i += 1
       sum = RationalSequence.new(i).to_a.reduce :+
      end
      RationalSequence.new(i-1).to_a
    end
  end

end
