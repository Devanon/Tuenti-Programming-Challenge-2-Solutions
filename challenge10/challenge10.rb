#!/usr/bin/env ruby

while !STDIN.eof?

  # Getting line from input
  line = gets.chomp.strip

  modded = true

  # Loop applying mods using regex
  while modded
    modded = false

    # Invert value
    if line =~ /(-?\d+) +mirror/
      temp_res = -1 * $1.to_i
      line.gsub!(/-?\d+ +mirror/, temp_res.to_s)
      modded = true
    end

    # Invert both values
    if line =~ /(-?\d+) +(-?\d+) +dance/
      temp_res1 = -1 * $1.to_i
      temp_res2 = -1 * $2.to_i
      line.gsub!(/-?\d+ +-?\d+ +dance/, temp_res1.to_s << ' ' << temp_res2.to_s)
      modded = true
    end

    # Duplicate value
    if line =~ /(-?\d+) +breadandfish/
      line.gsub!(/-?\d+ +breadandfish/, $1 << ' ' << $1)
      modded = true
    end

    # Multiply
    if line =~ /(-?\d+) +(-?\d+) +\#/
      temp_res = $1.to_i * $2.to_i
      line.gsub!(/-?\d+ +-?\d+ +\#/, temp_res.to_s)
      modded = true
    end

    # Divide
    if line =~ /(-?\d+) +(-?\d+) +\&/
      temp_res = $1.to_i / $2.to_i
      line.gsub!(/-?\d+ +-?\d+ +\&/, temp_res.to_s)
      modded = true
    end

    # Addition
    if line =~ /(-?\d+) +(-?\d+) +\@/
      temp_res = $1.to_i + $2.to_i
      line.gsub!(/-?\d+ +-?\d+ +\@/, temp_res.to_s)
      modded = true
    end

    # Substraction
    if line =~ /(-?\d+) +(-?\d+) +\$/
      temp_res = $1.to_i - $2.to_i
      line.gsub!(/-?\d+ +-?\d+ +\$/, temp_res.to_s)
      modded = true
    end

    # Modulus
    if line =~ /(-?\d+) +(-?\d+) +conquer/
      temp_res = $1.to_i % $2.to_i
      line.gsub!(/-?\d+ +-?\d+ +conquer/, temp_res.to_s)
      modded = true
    end

    # Maximum
    if line =~ /(-?\d+) +(-?\d+) +fire/
      temp_res = ($1.to_i > $2.to_i) ? $1 : $2
      line.gsub!(/-?\d+ +-?\d+ +fire/, temp_res.to_s)
      modded = true
    end

    # Remove end point
    line.gsub!(/ \.$/, '')

  end

  # Output
  puts line

end