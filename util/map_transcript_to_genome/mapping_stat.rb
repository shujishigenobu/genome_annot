jbgff = ARGV[0]
fasta = ARGV[1]

hitids = []
File.open(jbgff).each do |l|
  a = l.chomp.split(/\t/)
  if a[2] == "match"
    hitids << /^ID\=(\S+)/.match(a[8])[1]
  end
    
end

hitids = hitids.sort.uniq
p hitids.size

entry_ids = []
File.open(fasta).each do |l|
  if /^>/.match(l)
    entry_ids << l.split[0].sub(/^>/, '')
  else
    # do nothing
  end
end

entry_ids = entry_ids.sort.uniq

entry_ids.size

puts "#=== mapping statistics ==="
puts "#mapping result: #{jbgff}"
puts "#query sequence: #{fasta}"
printf("%d / %d (%.1f %%)\n", 
       hitids.size, entry_ids.size, hitids.size.to_f/entry_ids.size * 100)
