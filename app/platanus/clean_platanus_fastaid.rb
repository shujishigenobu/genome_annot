require 'bio'

include Bio

FlatFile.open(FastaFormat, ARGV[0]).each do |fas|
  name, cov = fas.entry_id.split(/_/)
#  p [name, cov]
  puts fas.seq.to_fasta("#{name} #{cov} length:#{fas.seq.length}", 60)
end
