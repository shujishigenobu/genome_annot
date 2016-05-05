cdsfasta = ARGV[0]
outfasta = File.basename(cdsfasta, ".fa") + ".longestCDS.fa"
outreport = File.basename(outfasta, ".fa") + ".report.txt"

require 'bio'

transcript_group = {} # key=representative_transcript, values=member ids
lengthdb = {}
seqdb = {}

Bio::FlatFile.open(Bio::FastaFormat, cdsfasta).each do |fas|
#  puts fas
#p [fas.entry_id, fas.seq.length]
  id = fas.entry_id
  lengthdb[id] = fas.seq.length
  seqdb[id] = fas
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

o1 = File.open(outfasta, "w")
o2 = File.open(outreport, "w")
transcript_group.keys.sort.each do |k|
  tps = transcript_group[k]
  tps_sorted_by_length = tps.sort{|a, b| lengthdb[b] <=> lengthdb[a]}
  longest = tps_sorted_by_length[0]
  o2.puts [k,
        tps.size,
        longest,
        tps.sort.map{|t| "#{t}(#{lengthdb[t]})"}.join(',')
       ].join("\t")
  o1.puts seqdb[longest]
end
o1.close
o2.close
