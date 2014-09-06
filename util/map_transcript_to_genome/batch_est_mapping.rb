require 'bio'
require 'tempfile'

query = ARGV[0]
db = ARGV[1]

Bio::FlatFile.open(Bio::FastaFormat, query).each do |fas|
  tf = Tempfile.new("#{fas.entry_id}")
  tf.puts fas
  tf.close
  cmd = "ruby est_mapping.rb #{tf.path} #{db}"
  IO.popen(cmd){|io| io.read}
end
