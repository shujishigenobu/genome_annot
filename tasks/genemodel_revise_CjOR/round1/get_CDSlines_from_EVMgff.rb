query = ARGV[0]
format = (ARGV[1] || "gff")
name = ARGV[2]
raise unless name


sourcef = "Source/Cjap_EVM6.gff3"
genome = "Cj4.genome.fasta"

gene_id_to_search = "evm.TU.#{query}"

cds_gff_lines = []

File.open(sourcef).each("\n\n") do |block|
#  puts block
#  puts "//"

  line0 = block.split(/\n/)[0]
  id_current = /ID\=(.+?);/.match(line0.split[-1])[1]
  if id_current == gene_id_to_search
#    puts block
    block.split(/\n/).each do |l|
      a = l.split(/\t/)
      if a[2] == "CDS"
        cds_gff_lines << l
      end
    end
    break
  end
end

if format == "gff"

  cds_gff_lines.each do |l|
    a = l.chomp.split(/\t/)
    b = a.dup
    b[1] = "manual"
    puts b.join("\t")
  end

end

## gff to bed12

strand = cds_gff_lines[0].split[6] # + or -

fragments = []
cds_gff_lines.each do |l|
  a = l.chomp.split(/\t/)

  fragments <<  [a[3].to_i, a[4].to_i]
  raise unless a[4].to_i > a[3].to_i

end

fragments = fragments.sort{|a, b| a[0] <=> b[0]}
starts = fragments.map{|f| f[0]}
ends   = fragments.map{|f| f[1]}


starts_zero_based = starts.map{|s| s - 1}
sizes = fragments.map{|f| f[1] - f[0] + 1}

from = starts_zero_based[0]
starts_on_fragment = starts_zero_based.map{|s| s - from}

score = 0 #dummy score
color = "0,0,0" #dummy color

dat = [cds_gff_lines[0].split[0],
       from,
       ends[-1],
       name,
       score,
       strand,
       starts_zero_based[0],
       ends[-1],
       color,
       fragments.size,
       sizes.join(","),
       starts_on_fragment.join(","),
      ]
puts dat.join("\t") if format == "bed"

exit unless format == "fasta"

cmd = "bedtools getfasta -fi #{genome} -bed stdin  -fo stdout -name -split -s | fold -w 60"
#puts cmd


IO.popen(cmd, "r+") do |io|
  io.puts dat.join("\t")
  io.close_write
  puts io.read
end
  
