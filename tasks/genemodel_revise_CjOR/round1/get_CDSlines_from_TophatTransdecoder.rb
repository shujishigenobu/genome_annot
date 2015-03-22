
query = ARGV[0]
format = (ARGV[1] || "gff")
name = ARGV[2]
raise unless name

sourcef = "Source/merged.fasta.transdecoder.genome.ed.gff3"
genome = "Cj4.genome.fasta"

cds_gff_lines = []
in_record = false

query2 = ""
query
format
name

if m = /(TCONS_\d+)\|\w\.(\d+)/.match(query)
  query1 = m[1]
  query2 = m[2]
elsif m = /TCONS_\d+/.match(query)
  query1 = m[0]
else
  raise "invalid query"
end



File.open(sourcef).each do |l|
  a = l.chomp.split(/\t/)
  if a[2] == "CDS"
    if /^ID\=cds\.#{query1}\|[gm]\.#{query2}/.match(a[8])
      cds_gff_lines << l
    end
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

line0data = cds_gff_lines[0].split(/\t/)
strand = line0data[6] # + or -
chromosome = line0data[0]

fragments = []
cds_gff_lines.each do |l|
  a = l.chomp.split(/\t/)

  fragments <<  [a[3].to_i, a[4].to_i]
  raise unless a[4].to_i > a[3].to_i

end

fragments = fragments.sort{|a, b| a[0] <=> b[0]}
starts = fragments.map{|f| f[0]}
ends   = fragments.map{|f| f[1]}

fragments

starts_zero_based = starts.map{|s| s - 1}.sort
sizes = fragments.map{|f| f[1] - f[0] + 1}

from = [starts_zero_based, ends].flatten.sort[0]
to = [starts_zero_based, ends].flatten.sort[-1]
starts_on_fragment = starts_zero_based.map{|s| s - from}

score = 0 #dummy score
color = "0,0,0" #dummy color

dat = [chromosome,
       from,
       to,
       name,
       score,
       strand,
       from,
       to,
       color,
       fragments.size,
       sizes.join(","),
       starts_on_fragment.join(","),
      ]
puts dat.join("\t") if format == "bed"

## dump fasta

exit unless format == "fasta"

cmd = "bedtools getfasta -fi #{genome} -bed stdin  -fo stdout -name -split -s | fold -w 60"
#puts cmd


IO.popen(cmd, "r+") do |io|
  io.puts dat.join("\t")
  io.close_write
  puts io.read
end
  
