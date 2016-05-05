mRNAfasta = ARGV[0]

require 'bio'

transcript_group = {} # key=representative_transcript, values=member ids

Bio::FlatFile.open(Bio::FastaFormat, mRNAfasta).each do |fas|
#  puts fas
#p [fas.entry_id, fas.seq.length]
  id = fas.entry_id
  if m = /\.\d+\.[a-f0-9]{8}/.match(id)
#    p id
    represent_tp = m.pre_match
    unless transcript_group.has_key?(represent_tp)
      transcript_group[represent_tp] = []
    end
    transcript_group[represent_tp] << id
  else
    unless transcript_group.has_key?(id)
      transcript_group[id] = []
    end
    transcript_group[id] << id
  end
end

transcript_group.keys.sort.each do |k|
  tps = transcript_group[k]
  puts [k,
        tps.size,
        tps.join(',')].join("\t")
        
end
