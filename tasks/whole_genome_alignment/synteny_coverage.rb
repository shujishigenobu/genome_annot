sizef = "Rspe02.sizes"
bed1 = "target.syn.net.tab4.toplevel"

chr_size = {}
File.open(sizef).each do |l|
  a = l.chomp.split(/\t/)
  chr = a[0]
  chr_size[chr] = a[1].to_i
end
#p chr_size


synteny_blocks = []

File.open(bed1).each do |l|
  a = l.chomp.split(/\t/)
  size = a[2].to_i - a[1].to_i
  synteny_blocks << [a[0],  size]
end

synteny_blocks.each do |c, s|
  csize = chr_size[c]
  puts [c, csize, s, sprintf("%.2f", s.to_f/csize*100) ].join("\t")

end

genome_size = chr_size.values.inject(0){|i, j| j += i}
total_size_synteny_covered = synteny_blocks.map{|a| a[1]}.inject(0){|i, j| j += i}
puts "#"
puts "# summary"
puts "# genome size: #{genome_size} bp"
printf("\# synteny covered: %d bp (%.1f%%)\n", 
       total_size_synteny_covered, 
       total_size_synteny_covered/genome_size.to_f * 100)


