ARGF.each do |l|
  a = l.chomp.split(/\t/)
  puts [a[0], a[14], a[11], a[1]].join("\t")
end
