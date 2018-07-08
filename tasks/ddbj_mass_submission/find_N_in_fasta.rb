require 'bio'
fastaf = ARGV[0]

Bio::FlatFile.open(fastaf).each do |fas|
  seq = fas.seq
#  p [fas.entry_id, seq.length]

  targetseq = seq.dup
  pos_curr = 0
  while m = /[Nn]+/.match(targetseq)
#    p pos_curr
#    p [m.begin(0), m.end(0), m.offset(0)]
    left = pos_curr + m.begin(0) # 0-based
    right = pos_curr + m.end(0) # 0-based
    bed = [fas.entry_id, left, right]
    targetseq = $'
    pos_curr += m.end(0)

    puts bed.join("\t")
  end

end
