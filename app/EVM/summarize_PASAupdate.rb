source = ARGV[0] #Dnox.EVM2.2.PASAupdated.gff3
cdsfasta = ARGV[1] #Dnox.EVM2.2PASA.cln.cds
outf1 = File.basename(source) + ".genes"
outf2 = File.basename(source) + ".transcripts"
outf3 = File.basename(cdsfasta) + ".longest_per_gene.fa"

genes = []
transcripts = []
File.open(source).each do |l|
  a = l.chomp.split(/\t/)
  next unless a.size == 9
  if a[2] == "gene"
    id = /^ID=(.+?);/.match(a[8])[1]
    genes << id
  elsif a[2] == "mRNA"
    m = /^ID=(.+?);Parent=(.+?);/.match(a[8])
    id = m[1].strip
    parent = m[2].strip
    transcripts << [id, parent]
  end
end

gene2transcripts = {}
transcripts.each do |t, g|
  unless gene2transcripts.has_key?(g)
    gene2transcripts[g] = []
  end
  gene2transcripts[g] << t
end

cdslen = {}
cdsfas = {}
require 'bio'
Bio::FlatFile.open(Bio::FastaFormat, cdsfasta).each do |fa|
  cdslen[fa.entry_id] = fa.seq.length
  cdsfas[fa.entry_id] = fa
end

o3 = File.open(outf3, "w")
File.open(outf1, "w"){|o|
  gene2transcripts.each do |g, tps|
    tps_sorted = tps.sort{|a, b| cdslen[b] <=> cdslen[a]}
#    tps_sorted.each do |tp|
#      p [tp, cdslen[tp]]
#    end
    longest = tps_sorted.first
    o.puts [g, 
            tps_sorted.size, 
            tps_sorted.join(","),
            tps_sorted.map{|t| cdslen[t]}.join(","),
            longest,
           ].join("\t")

    o3.puts cdsfas[longest]
  end

}

o3.close

exit

p transcripts
