#!/usr/bin/env ruby
require 'digest'

starting_queue = ""
$transformations_per_serie = []
$total_series_num = 0

# Apply all the transformations to a given person
def transform(init_person)
  
  queue = init_person
  
  i = 0
  while i < $total_series_num 

    next_queue = ""

    # Loop over people on the queue transforming or not and adding to queue
    queue.each_char do |ppl|
      if $transformations_per_serie[i][ppl.to_sym] != nil # Cloning! :)
        next_queue << $transformations_per_serie[i][ppl.to_sym]
      
      else # What are you doing here!? Get back to the queue!
        next_queue << ppl
      end
    end
    queue = next_queue.dup

    i += 1
  end

  return queue
end

# Get input
while !STDIN.eof?
  line = gets.chomp.strip
  
  # If matches, it is a line giving transformationg information
  if line =~ /=>/
    temp_transform_hash = {}

    # Split to an array
    line.split(",").each do |conversion|
      # Split origin and end
      conversion = conversion.split("=>")
      temp_transform_hash[conversion[0].to_sym] = conversion[1]
    end

    # Add transformation to global array and increase series count
    $transformations_per_serie << temp_transform_hash.dup
    $total_series_num += 1
  
  # Else, its a line containing the people queue
  else
    starting_queue << line
  end
end


# MAIN

stored_transformations = {}
end_queue = ""

# Loop over the people on the queue
starting_queue.each_char do |ppl|

  if stored_transformations[ppl.to_sym] != nil # If we know how this is gonna end...
    # Add clones to the final queue
    end_queue << stored_transformations[ppl.to_sym]

  else # First time cloning this individual
    temp = transform(ppl.to_s) # Clone it!
    end_queue <<  temp # Add clones to the final queue
    stored_transformations[ppl.to_sym] = temp # Store transformation for efficiency
  end

end

# Output
puts Digest::MD5.hexdigest(end_queue)