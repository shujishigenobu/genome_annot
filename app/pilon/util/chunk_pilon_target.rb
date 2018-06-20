chunk_size = 4000000

length_file = ARGV[0]
# format of length file
# contig_name <tab> length
contigs = []
File.open(length_file).each do |l|
  a = l.chomp.split(/\t/)
  name = a[0]
  len = a[1].to_i
  contigs << {:name => name, :len => len}

end

chunks = []
chunk_curr = []
#chunks << {:name => 'dummy', :len => 0}
#p chunks
contigs.each do |c|
  prev_sum = chunk_curr.map{|cc| c[:len]}.inject(0){|n, sum| sum +=n}
  if prev_sum + c[:len] > chunk_size
    chunks << [chunk_curr, c].flatten
    chunk_curr = []
  else
    chunk_curr << c
  end

end

chunks << chunk_curr

chunks.each_with_index do |c, i|
  puts ["Chunk_#{i}",
        c.map{|x| x[:name]}.join(",")].join("\t")
end
