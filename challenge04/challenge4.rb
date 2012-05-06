#!/usr/bin/env ruby

test_cases = STDIN.gets.chomp.to_i

while test_cases > 0

  # Getting first line
  line = gets.chomp.strip.split(/ /)

  races = line.shift.to_i     # Number of races
  karts = line.shift.to_i     # Number of karts
  groups = line.shift.to_i    # Number of groups

  groups_array = gets.chomp.strip.split(/ /)  # Groups data array

  # Create and array and calculate some data that will be used a lot of times during races simulation
  # Starting with each group calculate how many groups can be hold on circuit before running out of
  # karts, and whats the next "first group" on the queue 
  data_array = []

  groups_array.each_with_index do |people_on_group, index|
    ocuppied_karts = people_on_group.to_i
    next_group = (index + 1) % groups

    while karts - ocuppied_karts >= groups_array[next_group].to_i && next_group != index

      ocuppied_karts += groups_array[next_group].to_i
      next_group = (next_group + 1) % groups
    end

    data_array[index] = ocuppied_karts.to_i, next_group.to_i
  end

  # Races simulation
  current_gas = 0
  first_group = 0

  while races > 0
    current_gas += data_array[first_group][0]
    first_group = data_array[first_group][1]

    races -= 1
  end

  # Output
  p current_gas

  test_cases -= 1
end