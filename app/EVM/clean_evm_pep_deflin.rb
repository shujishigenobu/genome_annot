ARGF.each do |l|
  if /^>/.match(l)
    puts l.sub(/\034/,':')
  else
    puts l
  end
end
