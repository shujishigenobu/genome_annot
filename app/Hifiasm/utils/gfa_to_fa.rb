#!/bin/env ruby

gfa = ARGV[0]

File.open(gfa).each do |l|
  a = l.chomp.split(/\t/)
  if /^S/.match(l)
    id = a[1]
    desc = "#{a[1]} length=#{a[2].size}"
    puts ">#{id} #{desc}"
    puts a[2]
  else
  end
end

