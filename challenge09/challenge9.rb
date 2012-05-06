#!/usr/bin/env ruby

# Find function
def find_in_files(word, occurence)

  # Create the regex for the given word
  word_regex = Regexp.new('\b' << word.to_s << '\b', Regexp::IGNORECASE)

  found = false
  current_file = 1
  occurence_number = 0

  # Loop over the files until found the number of times
  while !found && current_file <= 800

    File.open("documents/" << current_file.to_s.rjust(4, '0'), "r") do |file|

      # Loop over the lines in the file
      file.each_with_index do |line, line_number|
        next if line =~ /^\n/

        # Match line against the regex
        match_data = line.scan(word_regex)
        if !match_data.empty?

          # In this line is the word we are looking for
          if occurence_number + match_data.length >= occurence

            line = line.split(' ')
            offset = 0

            # Calculate offset from the start of the line
            line.each_with_index do |w, index|
              occurence_number += 1 if w.downcase == word.downcase
              if occurence_number == occurence
                offset = index + 1
              end
              break if offset != 0 
            end

            # Output
            puts "#{current_file}-#{line_number + 1}-#{offset}"
            found = true

          else # Add number of occurences in this line and keep searching
            occurence_number += match_data.length
          
          end
        end

        break if found
      end

    end

    current_file += 1
  end
end


# MAIN

# Get number of cases and loop over it
cases_number = gets.chomp.strip.to_i

i = 0
while i < cases_number

  input = gets.chomp.strip

  input =~ / (\d+)/
  word = $`.to_s
  occurence = $1.to_i

  find_in_files(word, occurence)

  i += 1
end