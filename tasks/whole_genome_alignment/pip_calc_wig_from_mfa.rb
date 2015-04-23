name1, name2 = nil, nil
seq1, seq2 = "", ""
ARGF.each do |l|
  if (m = /^>/.match(l)) && name1 == nil
    name1 = m.post_match.split[0]
    elsif (m = /^>/.match(l)) && name2 == nil
    name2 = m.post_match.split[0]
    elsif name1 && name2 == nil
    seq1 << l.chomp
    elsif name2
    seq2 << l.chomp
    else
    raise
    end
end

name1orig = name1
name2orig = name2

name1 = name1.sub(/^lcl\|/, '')
name2 = name2.sub(/^lcl\|/, '')

m1 = /^(.+):(\d+)\-(\d+)$/.match(name1)
name1 = m1[1]
name1_from = m1[2].to_i
name1_to = m1[3].to_i

m2 = /^(.+):c*(\d+)\-(\d+)$/.match(name2)
name2 = m2[1]
name2_from = m1[2].to_i
name2_to = m1[3].to_i
name2_compl = true if /^.+:c\d+\-\d+$/.match(name2orig)


#p seq1
#p seq2

len = seq1.size
len = seq2.size



window = 50
step = 20
chrom = name1

seq1a = seq1.split(//)
seq2a = seq2.split(//)
seq1new = []
seq2new = []
seq1a.each_with_index do |s, i|
  seq1s = seq1a[i]
  seq2s = seq2a[i]

  if seq2s == "-"
    seq1new << seq1s
    seq2new << seq2s
  elsif seq1s == "-"
    # do nothing
  else
    seq1new << seq1s
    seq2new << seq2s
  end
end

#puts seq1new.join
#puts seq1a.size
#puts seq1new.size
#puts seq2a.size
#puts seq2new.size



i = 0

puts "variableStep  chrom=#{chrom}  span=#{step}"
while i + window < seq1new.length

  #puts i

  s1 = seq1new[i, window]
  s2 = seq2new[i, window]

  #s1 = seq1p.split(//)
  #s2 = seq2p.split(//)
  ident_ary = s1.zip(s2).map{|a, b|   a == b ? 1 : 0}

  ident_count = ident_ary.inject(0){|i, j| j += i}
  ident_ratio = ident_count / window.to_f


  puts [i + name1_from, ident_ratio].join("\t")

  i += step

end
