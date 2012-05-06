#!/usr/bin/env ruby

subcodes_array = []
passwd = {}
passwd_length = 0
passwd_changed = true
used_chars = ""


# Get input and store subcodes to an array
while !STDIN.eof?
  subcode = gets.chomp.strip
  subcodes_array << subcode
end

# Loop over the subcodes array until no modification done to the password
while passwd_changed == true

  passwd_changed = false

  # Loop subcodes
  subcodes_array.each do |subcode|

    insert_pos = 0

    # Loop over chars of the subcode
    subcode.each_char do |char|
      
      if passwd[char.to_sym] == nil # This characte is not in the password yet
        passwd[char.to_sym] = insert_pos
        insert_pos += 1
        used_chars << char
        passwd_changed = true

      else # The password contains the character...

        if passwd[char.to_sym] < insert_pos # ... but it is misplaced
          used_chars.each_char do |c|
            if passwd[c.to_sym] >= insert_pos
              passwd[c.to_sym] += 1
            end
          end
          passwd[char.to_sym] = insert_pos
          insert_pos += 1
          passwd_changed = true    


        else # ... and it is in correct position
          insert_pos = passwd[char.to_sym] + 1

        end
      end
    end
  end
end
passwd_length = passwd.values.sort[-1] + 1

# Get characters dependecies. Creates a hash storing information about the characters that
# can be in front of others
blocks_hash = {}
blocks_hash.default = []

subcodes_array.each do |subcode|
  previous_char = nil
  subcode.each_char do |char|
    blocks_hash[previous_char.to_sym] = blocks_hash[previous_char.to_sym].dup << char if previous_char != nil
    previous_char = char
  end
end
blocks_hash.each_pair { |k, v| v.uniq! }

passwords_array = []

# Expand unblocked characters. If a character can be one or more positions ahead, create a new
# password hash with the new position
i = 0
while i < passwd_length
  if passwd.values.count(i) > 1 
    passwd.each_pair do |k1, v1|
      if v1 == i
        blocked = false
        j = i + 1
        while !blocked && j < passwd_length
          passwd.each_pair do |k2, v2| 
            if v2 == j && blocks_hash[k1].include?(k2.to_s)
              blocked = true
            end
          end
          if !blocked
            temp_passwd = passwd.dup
            temp_passwd[k1] = j
            passwords_array << temp_passwd
          end
          j += 1
        end
        passwords_array << passwd.dup
      end
    end
  end

  i += 1
end
passwords_array.uniq!

# Prepare output
output = []

# Loop over every hash used to store the positions of characters in the password
passwords_array.each do |pw|
  solutions = [""]
  i = 0
  while i < passwd_length
    if pw.values.count(i) == 0 # No character on this position, skip
        i += 1
        next
      
    elsif pw.values.count(i) == 1 # Add the character on this position to every solution
      pw.each_pair do |key, value|
        if value == i
          solutions.each do |sol|
            sol << key.to_s
          end
        end
      end
    
    else # More than one possible character for this position
      
      # Generate all possible permutations
      temp_chars = ""
      pw.each_pair do |key, value|
        temp_chars << key.to_s if value == i
      end
      char_permutations = temp_chars.split("").permutation.to_a
      char_permutations.each_with_index do |ar, index|
        char_permutations[index] = ar.join("")
      end

      # Create new solution for every permutation
      new_solutions = []
      char_permutations.each do |op|
        solutions.each do |sol|
          sol += op
          new_solutions << sol  
        end
      end

      # Change pointing address of the solution array
      solutions = new_solutions
    end

    i += 1
  end
  output << solutions.dup
end

# Order, remove duplicates and print
puts output.flatten!.uniq!.sort!