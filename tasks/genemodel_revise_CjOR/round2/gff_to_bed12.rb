gff = ARGV[0]
name = ARGV[1]
format = (ARGV[2] || "bed")
#raise unless name

genome = "Cj4.genome.fasta"

unless name
  name = File.basename(gff, ".gff")
end

blocks = []
#cds_gff_lines = []

File.open(gff).each do |l|
  if /^\# Hit/.match(l)
    blocks << []
  elsif /^\#/.match(l)
    # do nothing
  else
    blocks.last << l
  end
end


## gff to bed12
blocks.each_with_index do |cds_gff_lines, i|
  line0data = cds_gff_lines[0].split(/\t/)
  strand = line0data[6] # + or -
  chromosome = line0data[0]

  fragments = []
  cds_gff_lines.each do |l|
    a = l.chomp.split(/\t/)
#    p a
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
    thisname = "#{name}.#{i+1}"

dat = [chromosome,
       from,
       ends[-1],
       thisname,
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
end

## dump fasta

exit unless format == "fasta"

cmd = "bedtools getfasta -fi #{genome} -bed stdin  -fo stdout -name -split | fold -w 60"
#puts cmd


IO.popen(cmd, "r+") do |io|
  io.puts dat.join("\t")
  io.close_write
  puts io.read
end
  
