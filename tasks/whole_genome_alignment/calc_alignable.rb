# calc_alignable.rb 2899.lagan.out.mfa


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


seq1a = seq1.split(//)
seq2a = seq2.split(//)

num_alignable = 0

seq1a.each_with_index do |s, i|
  seq1s = seq1a[i]
  seq2s = seq2a[i]

  if seq2s != "-" && seq1s != "-"
    num_alignable += 1
  end
end

puts num_alignable

#puts seq1new.join
#puts seq1a.size
#puts seq1new.size
#puts seq2a.size
#puts seq2new.size



#puts seq1new.join
#puts seq2new.join

