ARGF.each do |l|
  puts l.sub(/Name\=.+/, "")
end
