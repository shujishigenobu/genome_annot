require 'tempfile'
 
query = ARGV[0] # a single fasta (est)
genome = "../../Rspe02.final.assembly.fasta" # should be blast formated
 
## step 0: read query
 
qfasta = File.open(query).read
qid = /^>(.+?)\s/.match(qfasta)[1]
 
## step 1: megablast
 
cmd = "blastn -task megablast -db #{genome} -query #{query} -num_descriptions 10 -soft_masking yes -outfmt 6 -evalue 1.0e-40 -perc_identity 97.0"
puts cmd
res = nil
IO.popen(cmd){|io| res = io.read}
p res
if res == ""
## no hit
else
  top_chromosome = res.split(/\n/)[0].split(/\t/)[1]
end
 
## get top hit
 
cmd = "blastdbcmd -db #{genome} -entry #{top_chromosome}"
res = nil
IO.popen(cmd){|io| res = io.read}
 
tf = Tempfile.new("#{query}-#{top_chromosome}")
tf.puts(res.sub(/lcl\|/, ""))
tf.close
 
## exonerate
 
cmd = "exonerate -q #{query} -t #{tf.path} --model est2genome --bestn 1 --showquerygff yes --showtargetgff yes --showcigar yes"
res = nil
IO.popen(cmd){|io| res = io.read}
 
qid2 = qid.split(/\|/).compact.last
 
outf = "#{qid2}.exonerate"
File.open(outf, "w"){|o| o.puts res}
