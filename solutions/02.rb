def next_move(snake, direction)
  [snake[-1][0] + direction[0], snake[-1][1] + direction[1]]
end

def move(snake, direction)
  snake.drop(1) + [next_move(snake, direction)]
end

def grow(snake, direction)
  snake + [next_move(snake, direction)]
end

def make_food(dimensions)
  [] << rand(0...dimensions[:width]) << rand(0...dimensions[:height])
end

def new_food(food, snake, dimensions)
  fresh_food = make_food(dimensions)
  if food.include?(fresh_food) || snake.include?(fresh_food)
    new_food(food, snake, dimensions)
  else
    fresh_food
  end
end

def obstacle_ahead?(snake, direction, dimensions)
  move = next_move(snake, direction)
  move[0] < 0 || move[0] >= 10 || move[1] < 0 ||
  move[1] >= 10 || snake.include?(move)
end

def danger?(snake, direction, dimensions)
  new_direction = direction.collect { |n| n*2 }

  obstacle_ahead?(snake, direction, dimensions) ||
  obstacle_ahead?(snake, new_direction, dimensions)
end
