#!/usr/bin/env ruby

# Movement costs
MovV = 300
MovH = 200
MovD = 350
# Keys costs
Press = 100
RepeatKey = 500
# Mobile keyboard
Keyboard = [[" ", "1"], %w(a b c 2), %w(d e f 3), %w(g h i 4), %w(j k l 5), %w(m n o 6), 
  %w(p q r s 7), %w(t u v 8), %w(w x y z 9), [], %w(0), ["Mayus"]]

# Get movement cost and to letter and presses
def get_key_and_presses(letter)
  Keyboard.each_with_index do |key, index|
    if key.include? letter
      return index.to_i, key.index(letter).to_i + 1
    end
  end
end

# Movement cost function
def mov_cost(end_key)
  h_mov = ((end_key % 3) - ($finger_pos.to_i % 3)).abs
  v_mov = (end_key - (end_key % 3) - ($finger_pos.to_i - ($finger_pos.to_i % 3))).abs / 3
  d_mov = 0

  # Use diagonals if possible
  while v_mov > 0 && h_mov > 0
    d_mov += 1
    h_mov -= 1
    v_mov -= 1
  end
  
  # Change current position
  $finger_pos = end_key

  return d_mov * MovD.to_i + h_mov * MovH.to_i + v_mov * MovV.to_i 
end


# MAIN

test_cases = STDIN.gets.chomp.to_i

while test_cases > 0

  $finger_pos = 10
  $upcase_active = false
  current_cost = 0

  line = STDIN.gets.chomp

  line.each_char do |letter|

    # Check if a upper/down state change is needed and do it
    if (letter =~ /[A-Z]/ && !$upcase_active) || (letter =~ /[a-z]/ && $upcase_active)
      current_cost += mov_cost(11) + Press.to_i
      $upcase_active = !$upcase_active
    end

    # Go to next key or wait
    next_pos, num_presses = get_key_and_presses(letter.downcase)
    if next_pos != $finger_pos.to_i
      current_cost += mov_cost(next_pos)
    else
      current_cost += RepeatKey.to_i
    end

    # Add press cost
    current_cost += num_presses * Press.to_i
  end

  # Output
  puts current_cost

  test_cases -= 1
end