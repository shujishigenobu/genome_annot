require 'bio'
include Bio

#require 'pp'
#alias :p :pp

ref_proteome_file = (ARGV[0] || "/home/DB/public/processed/OrthoDB/OrthoDB7/blastdb/DMELA.Drosophila_melanogaster.fas")
blast_res_file = (ARGV[1] || "BLAST_DMELA/RsGM3.evm.out.combined.pep.vs.DMELA.Drosophila_melanogaster.fas.blastp.fmt7c.txt")
# query_file = ARGV[2] # query fasta

## print header of report
puts "#=== HIT COVERAGE STATISTICS ==="
puts "# "
puts "# date:   #{Time.now}"
puts "# script: #{$0}"
puts "# user:   #{ENV['USER']}@#{ENV['HOSTNAME']}"
puts "#"
puts "# Reference proteome: #{ref_proteome_file}"
puts "# BLAST result: #{blast_res_file}"
puts "#"
puts "#= Database side statistics "

## inspect reference proteome fasta

refp_total = 0 # aa
refp_ids = []
FlatFile.open(FastaFormat, ref_proteome_file).each do |fas|
  refp_ids << fas.entry_id
  refp_total += fas.seq.length
end

puts "num of reference proteins: #{refp_ids.size}"
puts "total length (aa): #{refp_total}"

## Parse blast (format 7 or 6)
##  get top hit only

blast_res_top = {}
q_curr =nil
s_curr = nil

i = 0
queries_with_hits = []
File.open(blast_res_file).each do |l|
#  puts l
  next if /^\#/.match(l)
  a = l.chomp.split(/\t/)
  query = a[0]
  subject = a[1]
  unless blast_res_top.has_key?(query)
    blast_res_top[query] = []
    q_curr = query
    s_curr = subject
    queries_with_hits << query
  end
  if query == q_curr && subject == s_curr
    blast_res_top[query] << a
  end

  i += 1
#  break if i >100
end

## output in bed format
tmpf = "tmp.bed"
io = File.open(tmpf, "w")
blast_res_top.each do |q, hits|
  hits.each do |h|
    ary = [h[1],
           h[8].to_i,
           h[9].to_i,
           h[0],
           h[2].to_f,
           "+",
          ]
    io.puts ary.join("\t")
  end
end
io.close

cmd = "sort -k1,1 -k2,2n tmp.bed > tmp.sorted.bed"

system cmd

outf = "merged.bed"
cmd = "mergeBed  -i tmp.sorted.bed > #{outf}"

system cmd

data = {}
File.open(outf).each do |l|
  a = l.chomp.split(/\t/)
  key = a[0]
  unless data.has_key?(key)
    data[key] = {}
    data[key]['hsps'] = []
  end
  data[key]['hsps'] << [a[1].to_i, a[2].to_i]
end

data.keys.sort.each do |k|
#p  data[k]['hsps']
  cov_len = data[k]['hsps'].map{|hsp| hsp[1] - hsp[0] + 1}.inject(0){|sum, i|  sum + i}
  
  data[k]['cov_len'] = cov_len
end

total_hit_cov = 0
data.keys.sort.each do |k|
  total_hit_cov += data[k]['cov_len']
#  puts [k,
#        data[k]['cov_len']
#       ].join("\t")
end

num_hit_genes = data.keys.size

puts sprintf("num of hits: %d (%.1f %%)", num_hit_genes, num_hit_genes / refp_ids.size.to_f * 100) 
puts sprintf("hit coverage (aa): %d (%.1f %%)", total_hit_cov, total_hit_cov / refp_total.to_f * 100)


## Parse blast results again
##  to inspect query side information
##  blast output should be formated in format7


queries = []
File.open(blast_res_file).each do |l|
  
  if m = /^\# Query:/.match(l)
    qname = m.post_match.strip.split[0]
    queries << qname
  end
end

puts "#"
puts "#= Query side statistics "
puts sprintf("num of queries: %d", queries.size)
puts sprintf("num of queries with hits: %d (%.1f %%)", queries_with_hits.size, queries_with_hits.size / queries.size.to_f * 100)
