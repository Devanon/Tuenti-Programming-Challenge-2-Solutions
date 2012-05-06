#!/usr/bin/env ruby
require 'date'

# Leds turned on to show a digit 
Segments_leds = [0x7E, 0x30, 0x6D, 0x79, 0x33, 0x5B, 0x5F, 0x70, 0x7F, 0x7B]


# Increase de clock 1 second
def increase_time(starting_time)
  increased_time = starting_time.dup

  # Increase seconds
  increased_time[2] = ((starting_time[2].to_i + 1) % 60).to_s.rjust(2, '0')
  
  # Increase minutes when needed
  if increased_time[2] == "00"
    increased_time[1] = ((starting_time[1].to_i + 1) % 60).to_s.rjust(2, '0')
    
    # Increase hours when needed
    if increased_time[1] == "00"
      increased_time[0] = ((starting_time[0].to_i + 1) % 24).to_s.rjust(2, '0')
    end
  end

  return increased_time
end

# Calculate change cost for a given pair of displays
def num_change_cost(start_num, end_num, clock_type)

  # Separate digits of each number
  strt_d0, strt_d1 = start_num[0].to_i, start_num[1].to_i
  end_d0, end_d1 = end_num[0].to_i, end_num[1].to_i
  cost = 0
  
  if clock_type == 0 # Old clock
    cost += Segments_leds[end_d0].to_s(base=2).count('1')
    cost += Segments_leds[end_d1].to_s(base=2).count('1')

  else # New clock
    cost += (~Segments_leds[strt_d0] & Segments_leds[end_d0]).to_s(base=2).count('1') if strt_d0 != end_d0
    cost += (~Segments_leds[strt_d1] & Segments_leds[end_d1]).to_s(base=2).count('1')
  end

  return cost
end

# Calculare cost for increasing the time 1 second
def clock_change_cost(starting_time, clock_type)

  cost = 0
  increased_time = increase_time(starting_time)
  
  for i in 0 .. 2
    cost += num_change_cost(starting_time[i].to_s.rjust(2, '0'), increased_time[i].to_s.rjust(2, '0'), clock_type)
  end

  return cost
end


# MAIN

# Simulate a complete day to improve speed
start_time = ["00", "00", "00"]
end_time = ["23", "59", "59"]
old_1day = 36
new_1day = 10

while start_time != end_time
  old_1day += clock_change_cost(start_time, 0)
  new_1day += clock_change_cost(start_time, 1)

  start_time = increase_time(start_time)
end

# Loop while input exists
while !STDIN.eof?
  input_line = gets.chomp.strip

  # Get data from the string given as input
  #              |--$1-------------| |--$2-------------|   |--$3-------------| |--$4-------------|
  input_line =~ /(\d{4}-\d{2}-\d{2}) (\d{2}:\d{2}:\d{2}) - (\d{4}-\d{2}-\d{2}) (\d{2}:\d{2}:\d{2})/

  start_date = Date.parse($1)
  start_time = $2
  end_date = Date.parse($3)
  end_time = $4

  # Convert to arrays -> ["hours", "minutes", "seconds"]
  start_time = start_time.split(/:/)
  end_time = end_time.split(/:/)

  # Start cost. All digits set to 0
  old_cost = 36
  new_cost = 36

  # Loop until time reached
  while start_time != end_time
    old_cost += clock_change_cost(start_time, 0)
    new_cost += clock_change_cost(start_time, 1)

    start_time = increase_time(start_time)
  end
  
  # Add cost from looping complete days
  days = end_date.ld - start_date.ld
  old_cost += days * old_1day
  new_cost += days * new_1day

  # Output
  puts (old_cost - new_cost)

end