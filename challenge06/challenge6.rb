#!/usr/bin/env ruby

# Get number of cases
num_cases = gets.chomp.to_i

# Loop trough all the cases
case_count = 1
while case_count <= num_cases

  # Get lines from input
  sizes = gets.chomp.strip
  message = gets.chomp.strip.split(/ /).reject { |word| word == "" }

  # Extract width, height and ct from string
  sizes =~ /(\d+) (\d+) (\d+)/

  ct = $3.to_i
  width = $1.to_i * ct
  height = $2.to_i * ct

  # Start font size = (length of longest word / width * ct)
  font_size = width / message.sort{ |x,y| x.length <=> y.length }.length
  max_size_found = false
  temp_msg = []

  # Split message on lines for every font size down to 0, untilone is valid or 0 reached
  while font_size > 0 && !max_size_found
    lines = height / font_size

    ac = 0
    start_slice = 0
    temp_msg = []
    error_num = 0
    
    i = 0
    while i < message.length

      # Not reached fabric width, go to the next word
      if ac + ((message[i].length + 1) * font_size) <= width + 1 * font_size
        ac += ((message[i].length + 1) * font_size)
        error_num = 0
        i += 1
      
      # Current words width is bigger than fabric. Those form a line
      else
        temp_msg << message.slice(start_slice, i - start_slice)
        start_slice = i
        ac = 0

        # Break if 2 consecutive errors, to improve efficiency
        if error_num == 1 then break else error_num += 1 end
      end
    end
    # Add last words
    temp_msg << message.slice(start_slice, i - start_slice)

    # If lines used are possible given height and font size, and all words written...
    if temp_msg.length <= lines && temp_msg.flatten.length == message.length
      max_size_found = true
    end

    # Decrease font size for next loop if not a valid one
    font_size -= 1 if !max_size_found
  end

  # Get number of characters to stitch
  chars_to_stitch = message.join("").length

  # Output
  if font_size == 0
    puts "Case ##{case_count}: 0"
  else
    # Ouput the minimum thread length needed
    puts "Case ##{case_count}: #{(((font_size**2).to_f / (2 * ct)) * chars_to_stitch).ceil.to_i}"
  end

  case_count += 1
end