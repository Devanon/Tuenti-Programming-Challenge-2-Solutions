#!/usr/bin/env ruby

# Get test number
test_cases = STDIN.gets.chomp.to_i

test_number = 1
while test_number <= test_cases

  # Get N number from input
  decimal_N = STDIN.gets.chomp.to_i
  binary_N = decimal_N.to_s(2)

  binary_X = binary_N

  # Odd number smaller than N, with maximum number of 1's
  i = binary_X.index('1')
  binary_X[i] = '0'
  i += 1
  while i < binary_X.length
    binary_X[i] = '1'
    i += 1
  end

  # y = N -x
  decimal_X = binary_X.to_i(base=2)
  decimal_Y = decimal_N - decimal_X
  binary_Y = decimal_Y.to_s(2)

  # Sum 1's on both numbers
  max_hazelnuts = binary_X.count('1') + binary_Y.count('1')
  
  # Output
  puts "Case ##{test_number}: #{max_hazelnuts}"

  test_number += 1
end