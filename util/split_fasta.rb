begin
  require 'rubygems'
rescue LoadError
end
require 'bio'

include Bio

$fastaf = ARGV[0]
$num_entries = ARGV[1].to_i
$outdir = ARGV[2]
$header = ARGV[3]

def print_help
  puts "Usage:"
  puts "  #{File.basename($0)}  fasta_file  num_entries_per_file  [target_dir]"
  puts ""
  exit
end

unless (ARGV.size == 3 || ARGV.size == 2 || ARGV.size == 4)
  print_help
end

unless $outdir
  $outdir = "fasta_split"
end
if File.exists?($outdir)
  raise "\nERROR: Directory, #{$outdir}, already exists."
else
  Dir.mkdir($outdir)
  STDERR.puts "outdir: #{$outdir}"
end
$listf = "#{$outdir}.list"
listf = File.open($listf, "w")
listf.puts $header if $header

container = []
i = 0
FlatFile.open(FastaFormat, ARGV[0]).each do |fas|
  container << fas
  if container.size == $num_entries
    outf = File.basename($fastaf) + "_#{i+=1}.fasta"
    outpath = $outdir + "/" + outf
    STDERR.puts [outpath, container.size].join("\t")
    File.open(outpath, "w"){|o| o.puts container}
    listf.puts outpath
    container = []
  end
end




outf = File.basename($fastaf) + "_#{i+=1}.fasta"

outpath = $outdir + "/" + outf
File.open(outpath, "w"){|o|  o.puts container}
listf.puts outpath

STDERR.puts [outpath, container.size].join("\t")
listf.close
