exonerate_out = ARGV[0]

name = nil
target = nil
File.open(exonerate_out).each do |l|
  
  if m = /\s+Query:\s/.match(l)
    name = m.post_match.chomp.split[0]
  elsif m = /\s+Target:\s/.match(l)
    target = m.post_match.split[0]
  elsif /^#{target}/.match(l) &&
      (/\texonerate:est2genome\t/.match(l) || /\texonerate:protein2genome:local\t/.match(l)) &&
      (/\tcds\t/.match(l) || /\tgene\t/.match(l))
    a = l.chomp.split(/\t/)
    b = a.dup
    if b[2] == "gene"
      b[-1] = "gene_id \"#{name}\"; transcript_id \"#{name}\"; #{a.last.chomp}"
    elsif b[2] == "cds"
      b[-1] = "gene_id \"#{name}\"; transcript_id \"#{name}\"; #{a.last.chomp}"
    else
      raise
    end
    puts b.join("\t")
  end

end
# puts [name, target]
