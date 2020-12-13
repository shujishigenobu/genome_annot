fastaf = ARGV[0]

require 'bio'
include Bio

FlatFile.open(FastaFormat, fastaf).each do |fas|
#  puts fas.entry_id
  newseq = fas.seq.sub(/\*$/, "")
  puts newseq.to_fasta(fas.entry_id, 60)
end
