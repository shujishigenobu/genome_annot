ingff = ARGV[0]
source = ARGV[1]

File.open(ingff).each("\n\n") do |block|
  cdss = []
  mRNA = nil
  gene = nil
  block.strip.split(/\n/).each do |l|
    a = l.chomp.split(/\t/)
    if source && a
      a[1] = source
    end
    case a[2]
    when "gene"
      gene = a.dup
    when "mRNA"
      mRNA = a.dup
    when "CDS"
      cdss << a
    else
      # discard UTR
    end
  end

#  p gene#
#  p mRNA
#  p cdss
  x = cdss.map{|c| [c[3].to_i, c[4].to_i]}.flatten.sort
  leftmost = x.first
  rightmost = x.last
  gene[3] = leftmost
  gene[4] = rightmost
  mRNA[3] = leftmost
  mRNA[4] = rightmost
  puts gene.join("\t")
  puts mRNA.join("\t")
  cdss.each do |c|
    puts c.join("\t")
  end
  puts ""
#  puts "//"

end
