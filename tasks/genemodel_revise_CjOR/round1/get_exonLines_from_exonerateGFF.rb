#exoneratef = ARGV[0]
query = ARGV[0]
format = (ARGV[1] || "gff")
name = ARGV[2]
raise unless name

source_dir = "Source/CDS_exonerate_outputs"
genome = "Cj4.genome.fasta"

# gene_id_to_search = "evm.TU.#{query}"
sourcef = "#{source_dir}/#{query}.exonerate"


exon_gff_lines = []
in_record = false

File.open(sourcef).each do |l|
  if /^\# --- START OF GFF DUMP ---/.match(l)
    in_record = true
  elsif /^\# --- END OF GFF DUMP ---/.match(l)
    in_record = false
  end

  next unless in_record
  next if /^\#/.match(l)

  a = l.chomp.split(/\t/)

  if a[2] == "exon"
    exon_gff_lines << l
  end
  
end


puts exon_gff_lines if format == "gff"

## gff to bed12

line0data = exon_gff_lines[0].split(/\t/)
strand = line0data[6] # + or -
chromosome = line0data[0]

fragments = []
exon_gff_lines.each do |l|
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

dat = [chromosome,
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

## dump fasta

exit unless format == "fasta"

cmd = "bedtools getfasta -fi #{genome} -bed stdin  -fo stdout -split -name -s | fold -w 60"
# puts cmd


IO.popen(cmd, "r+") do |io|
  io.puts dat.join("\t")
  io.close_write
  puts io.read
end
  
