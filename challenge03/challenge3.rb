#!/usr/bin/env ruby

Infinity = 1.0/0

def recursive_search(array, left_limit, right_limit)
  
  if (right_limit - left_limit) < 2
    return left_limit, right_limit, array[right_limit] - array[left_limit]
  end

  mid = (right_limit - left_limit) / 2
  minimum = mid
  maximum = mid + 1
  
  # Look minimum backward
  i = mid
  while i >= left_limit
    minimum = i if array[i] < array[minimum]
    i -= 1
  end
  # Look maximum forward
  i = mid + 1
  while i <= right_limit
    maximum = i if array[i] < array[maximum]
    i += 1
  end

  gain_complete = array[maximum] - array[minimum]

  # Recursive call
  min_left_half, max_left_half, gain_left_half = recursive_search(array, left_limit, mid)
  min_right_half, max_right_half, gain_right_half = recursive_search(array, mid + 1, right_limit)


  if gain_left_half > gain_right_half

    if gain_left_half > gain_complete
      return min_left_half, max_left_half, gain_left_half
    
    else
      return minimum, maximum, gain_complete
    
    end

  elsif gain_right_half > gain_complete 
    return min_right_half, max_right_half, gain_right_half
  
  else
    return minimum, maximum, gain_complete

  end
end


data = []

while !STDIN.eof?
  data << STDIN.gets.chomp.to_i
end

buy_point, sell_point, max_gain = recursive_search(data, 0, data.length - 1)

puts "#{buy_point*100} #{sell_point*100} #{max_gain}"