#!/usr/bin/env ruby

Letter_values = {
  :A => 1, :E => 1, :I => 1, :L => 1, :N => 1, :O => 1, :R => 1, :S => 1, :T => 1, :U => 1,
  :D => 2, :G => 2,
  :B => 3, :C => 3, :M => 3, :P => 3,
  :F => 4, :H => 4, :V => 4, :W => 4, :Y => 4,
  :K => 5,
  :J => 8, :X => 8,
  :Q => 10, :Z => 10 }

# Function to calculate the value of a word
def get_word_value(word)
  value = 0
  word.each_char do |chr|
    value += Letter_values[chr.upcase.to_sym]
  end

  return value
end

# Find the best possible word with the letters that the player has
def find_best_word(player_letters)

  temp_best_value = 0
  temp_best_word = ""

  File.open("wordlist.txt", "r") do |file|

    # Loop over all the possible words
    file.each do |word_from_list|

      word_checking = word_from_list.chomp
      temp_rack = player_letters.dup
      valid_word = true
      
      # Check if we have all the letters of the word
      word_checking.each_char do |letter_checking|

        # We need a letter that it is not in the player rack :(
        if !temp_rack.include?(letter_checking)
          valid_word = false
          break

        else # We have the letter, remove it from the player rack
          temp_rack[temp_rack.index(letter_checking)] = ''

        end
      end

      # That word can be played! Check if it is the best until now :)
      if valid_word
        temp_value = get_word_value(word_checking)
        if temp_value > temp_best_value
          temp_best_value = temp_value
          temp_best_word = word_checking
        
        end
      end
    end
  end

  return temp_best_word, temp_best_value
end


# MAIN

cases_number = gets.chomp.strip.to_i

i = 0
while i < cases_number

  line = gets.chomp.strip
  line =~ / /

  # Split info got from the input
  letters = $`
  word_on_board = $'

  tested_letters = ""
  best_words_array = [["", 0]]

  # For every letter of the word on board, add it to the player rack and play with it
  word_on_board.each_char do |lt|

    # Skip letters already checked
    next if tested_letters.include?(lt)

    tested_letters << lt
    word, value = find_best_word(letters + lt)

    # If the word returned is one of the bests, store it
    if value > best_words_array[0][1]
      best_words_array = [[word.dup, value]]
    
    elsif value == best_words_array[0][1]
      best_words_array << [word.dup, value]  

    end
  end

  # Output
  best_words_array.sort!
  puts "#{best_words_array[0][0]} #{best_words_array[0][1]}"

  i += 1
end