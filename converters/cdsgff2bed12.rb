lines = []
ARGF.each do |l|
  a = l.chomp.split(/\t/)
  chr = a[0]
  from = a[3].to_i - 1
  to = a[4].to_i
  name = a[2]
  score = 0
  strand = a[6]

  lines << [chr, from, to, name, score, strand]
  

end

#p lines
from = lines[0][1]
blockStarts = lines.map{|ln| ln[1] - from}
blockSizes = lines.map{|ln| ln[2] - ln[1]}

#blockSizes[-1] = blockSizes[-1] + 3

puts [lines[0][0], #1
      lines[0][1], #2
      lines[-1][2], #3
      "CDS", #4
      0, #5
      lines[0][5], #6
      nil, #7
      nil, #8
      nil, #9
      blockSizes.length,     #10
      blockSizes.join(','),  #11
      blockStarts.join(','), #12
      ].join("\t")
