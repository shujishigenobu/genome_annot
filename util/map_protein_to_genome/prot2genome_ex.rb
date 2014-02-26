require 'tempfile'
 
query = ARGV[0] # a single fasta (est)
genome = "../Rspe02.final.assembly.fasta" # should be blast formated
evalue = 1.0e-8
ncpu = 4
MAX_HSP_INTERVAL = 50000
EXTENSION = 50000

## step 0: read query
 
qfasta = File.open(query).read
qid = /^>(.+?)\s/.match(qfasta)[1]
 
## step 1: tblastn
 
cmd = "tblastn -db #{genome} -query #{query} -num_descriptions 10 -soft_masking yes -seg yes -outfmt 6 -evalue #{evalue} -num_threads #{ncpu} "
puts cmd
res = nil
IO.popen(cmd){|io| res = io.read}
puts res
if res == ""
## no hit
else
  lines = []
  prev_chr = nil
  res.split(/\n/).each do |l|
    p prev_chr
    a = l.chomp.split(/\t/)
    unless prev_chr
      lines << l
      prev_chr = a[1]
    else
      break if a[1] != prev_chr
      lines << l
      prev_chr = a[1]
    end 
  end

  a = lines.shift.chomp.split(/\t/)
  left, right = [a[8].to_i, a[9].to_i].sort
  
  p [left, right]

  lines.each do |l|
    a = l.chomp.split(/\t/)
    from, to = [a[8].to_i, a[9].to_i].sort
    tmpary = [left, right, from, to].sort
    new_left = tmpary.first
    new_right = tmpary.last
    if (new_left - left).abs < MAX_HSP_INTERVAL &&  (new_right - right).abs < MAX_HSP_INTERVAL
      right = new_right
      left  = new_left
    else
      break
    end
  end
  p [left, right]
  
p  top_chromosome = res.split(/\n/)[0].split(/\t/)[1]
end
 
## get top hit

cmd = "blastdbcmd -db #{genome} -entry #{top_chromosome} -outfmt %l "
res = nil
IO.popen(cmd){|io| res = io.read}
seqlength = res.to_i

left_extract = [(left - EXTENSION), 1].sort.last
right_extract = [(right + EXTENSION), seqlength].sort.first

#p [left_extract, right_extract]

cmd = "blastdbcmd -db #{genome} -entry #{top_chromosome} -range #{left_extract}-#{right_extract} -outfmt %s"
res = nil
IO.popen(cmd){|io| res = io.read}
seq = res.strip

seq = "n" * (left_extract - 1) + seq + "n" * (seqlength - right_extract)
# [res.size, seq.size, seqlength]
raise unless seq.size == seqlength
fas = ">#{top_chromosome}\n#{seq}"

tf = Tempfile.new("#{query}-#{top_chromosome}")
tf.puts(fas)
tf.close
 
## exonerate
 
cmd = "exonerate -q #{query} -t #{tf.path} --model protein2genome --bestn 1 --showquerygff yes --showtargetgff yes --showcigar yes"
res = nil
IO.popen(cmd){|io| res = io.read}
 
qid2 = qid.split(/\|/).compact.last
 
outf = "#{qid2}.exonerate"
File.open(outf, "w"){|o| o.puts res}
