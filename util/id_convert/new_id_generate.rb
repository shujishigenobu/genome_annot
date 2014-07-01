source = "EVM8.evm.sorted.gff3"

counter = 0

puts "# EVM8 ID Table; #{Time.now}"
puts "# new_id\told_id\tgff_record"
File.open(source).each do |l|
  a = l.chomp.split(/\t/)

  m = /scaffold_(\d+)\.(\d+)/.match(a[8])

  newid = sprintf("RS%06d", counter+=1)

  oldid = "evm.model.#{m[0]}"

  puts [newid, oldid, a].flatten.join("\t")
  
end
