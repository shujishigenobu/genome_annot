require 'bio'

fasta = ARGV[0]
Bio::FlatFile.open(Bio::FastaFormat, fasta).each do |fas|
#  puts fas.entry_id
  puts fas
  puts "//"

end
