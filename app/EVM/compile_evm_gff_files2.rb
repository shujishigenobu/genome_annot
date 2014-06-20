combined = "Release_RsGM7/EVM7.evm.out.gff3"
outdir = "gff3_by_scaffolds"
genome = "../../Rspe02.final.assembly.fasta"

scaffolds = []
File.open(genome).each do |l|
  if m = /^>/.match(l)
    scaffolds << m.post_match.chomp.strip
  else
  end
end

gffdata = {}
File.open(combined).each do |l|
  a = l.chomp.split(/\t/)
  next if a.size == 0
  if gffdata.has_key?(a[0])
    gffdata[a[0]] << a
  else
    gffdata[a[0]] = []
  end
end

scaffolds.each do |scaff|
  STDERR.puts "#{scaff}"
  outfile = "evm.out.#{scaff}.gff3"
  outpath = "#{outdir}/#{outfile}"
  File.open(outpath, "w"){|o|
    if gffdata[scaff]
      gffdata[scaff].each do |entry|
        o.puts entry.join("\t")
      end
    else
      o.puts ""
    end
  }
end


