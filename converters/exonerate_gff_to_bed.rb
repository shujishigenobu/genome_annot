exonerate_out = ARGV[0]

name = nil
target = nil
exon_entries = []
File.open(exonerate_out).each do |l|

  if m = /\s+Query:\s/.match(l)
    name = m.post_match.chomp.split[0]
  elsif m = /\s+Target:\s/.match(l)
    target = m.post_match.split[0]
  elsif /^#{target}/.match(l) && 
      (/\texonerate:est2genome\t/.match(l) || /\texonerate:protein2genome:local\t/.match(l)) && 
      /\texon\t/.match(l)
    a = l.chomp.split(/\t/)
    exon_entries << a

  end

end

 [name, target]
 exon_entries

 ex_starts = exon_entries.map{|ex| ex[3].to_i}
 ex_ends = exon_entries.map{|ex| ex[4].to_i}

 gene_start = [ex_starts, ex_ends].flatten.sort.first
 gene_end = [ex_starts, ex_ends].flatten.sort.last
# gene_end = ex_ends[-1]

 num_exons = exon_entries.size
 block_sizes = exon_entries.map{|ex| ex[4].to_i - ex[3].to_i + 1}

strand = exon_entries[0][6]

bed = [target, 
       gene_start - 1,
       gene_end, 
         name,
       1, #dummy score
       strand,
       gene_start - 1,
       gene_end,
       "0,255,0",
       num_exons,
       (strand == "+" ? block_sizes : block_sizes.reverse).join(","),
       (strand == "+" ? ex_starts.map{|e| e - gene_start } : ex_starts.map{|e| e- gene_start}.reverse).join(","),
      ]

puts bed.join("\t")

