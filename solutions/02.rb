def next_move(snake, direction)
  [snake.last[0] + direction[0], snake.last[1] + direction[1]]
end

def move(snake, direction)
  snake.drop(1) + [next_move(snake, direction)]
end

def grow(snake, direction)
  snake + [next_move(snake, direction)]
end

def make_food(dimensions)
  [*0...dimensions[:width]].product([*0...dimensions[:height]])
end

def new_food(food, snake, dimensions)
  fresh_food = make_food(dimensions)
  (fresh_food - (snake + food)).sample
end

def obstacle_ahead?(snake, direction, dimensions)
  move = next_move(snake, direction)
  move[0] < 0 or move[0] >= dimensions[:width] or move[1] < 0 or
  move[1] >= dimensions[:height] or snake.include?(move)
end

def danger?(snake, direction, dimensions)
  obstacle_ahead?(snake, direction, dimensions) or
  obstacle_ahead?(grow(snake, direction), direction, dimensions)
end
