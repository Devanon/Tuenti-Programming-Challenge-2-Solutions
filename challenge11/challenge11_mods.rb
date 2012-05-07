#!/usr/bin/env ruby

class String

  LETTER_VALUES = {
    :A => 1, :E => 1, :I => 1, :L => 1, :N => 1, :O => 1, :R => 1, :S => 1, :T => 1, :U => 1,
    :D => 2, :G => 2,
    :B => 3, :C => 3, :M => 3, :P => 3,
    :F => 4, :H => 4, :V => 4, :W => 4, :Y => 4,
    :K => 5,
    :J => 8, :X => 8,
    :Q => 10, :Z => 10 }

  def value
    value = 0
    self.each_char do |char|
      value += LETTER_VALUES[char.upcase.to_sym]
    end

    return value
  end

end

class DictionaryPreprocessor

  @@wordlist_file = 'wordlist.txt'

  def run
    words_array = []
    File.open(@@wordlist_file, "r") do |file|

      file.each do |word|
        word.chomp!
        words_array << [word.value, word.length, word]

      end
    end

    words_array.sort! { |x,y| [y[1], y[0], x[2]] <=> [x[1], x[0], y[2]] }

    length = words_array[0][1]
    first_pos_length = []
    first_pos_length << [length, 0]

    words_array.each_with_index do |word, index|
      next if length == word[1]

      first_pos_length << [word[1], index]
      length = word[1]
    end

    File.open(@@wordlist_file.gsub(/\..+?$/, '') + '_processed.txt', 'w') do |output_file|
      words_array.each do |word_data|
        output_file.puts "#{word_data[0]} #{word_data[1]} #{word_data[2]}"
      end
    end

    File.open(@@wordlist_file.gsub(/\..+?$/, '') + '_starting_lengths.txt', 'w') do |output_file|
      first_pos_length.each do |length_data|
        output_file.puts "#{length_data[0]} #{length_data[1]}"
      end
    end

  end

end

class Descrambler

  @@wordlist_file = 'wordlist_processed.txt'
  @@starting_lengths_file = 'wordlist_starting_lengths.txt'

  def initialize
    @wordlist_array = []
    @starting_length_pos = {}

    File.open(@@wordlist_file, "r") do |file|
      file.each do |line|
        line = line.chomp.split(/ /)
        @wordlist_array << [line[0].to_i, line[1].to_i, line[2].chomp]
      end
    end

    File.open(@@starting_lengths_file, "r") do |file|
      file.each do |line|
        line = line.chomp.split(/ /)
        @starting_length_pos[line[0].to_i] = line[1].to_i
      end
    end
  
  end

  def main

    cases = gets.chomp.strip.to_i

    cases.times do
      line = gets.chomp.strip.split(/ /)

      player_rack = line[0]
      h_word = line[1]
      best_playable_words = []

      h_word.each_char do |char|
        
        @wordlist_array.each_with_index do |word, index|
          next if index < @starting_length_pos[player_rack.length + 1]

          temp_rack = player_rack.dup << char

          playable_word = true

          word[2].each_char do |letter|
            playable_word = false if !temp_rack.include?(letter)
            break if !playable_word

            temp_rack[temp_rack.index(letter)] = ''
          end

          best_playable_words << word if playable_word
          break if playable_word

        end
      end

      best_playable_words.sort! { |x, y| [y[0], x[2]] <=> [x[0], y[2]] }
      puts "#{best_playable_words[0][2]} #{best_playable_words[0][0]}"

    end

  end

end

prep = DictionaryPreprocessor.new
prep.run

descrblr = Descrambler.new
descrblr.main