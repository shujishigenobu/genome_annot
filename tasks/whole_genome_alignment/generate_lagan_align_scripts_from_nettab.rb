require 'tempfile'

source = "target.syn.net.tab"
seq1 = "Cj_Or_scaffolds.fa.softmasked" # target (ref)
seq2 = "Cf_Or_scaffolds.fa.softmasked" # query

File.open(source).each_with_index do |l, i|
p  a = l.chomp.split(/\t/)
  name1 = a[0]
  from1 = a[1].to_i
  to1 = a[2].to_i
  name2 = a[3]
  score = a[4].to_i
  strand = a[5]
  from2 = a[6].to_i
  to2 = a[7].to_i

## filter by length
  size1 = to1 -from1
  next if size1 < 400
  
  cmd1 = "blastdbcmd -db #{seq1} -entry #{name1} -range #{from1 + 1}-#{to1} "
#  cmd1 << (strand == "+" ? 'plus' : 'minus')
#  puts cmd

  t1 = File.new("#{i}.seq1", "w")
  IO.popen(cmd1){|io|
    res = io.read
    t1.puts res
  }
  t1.close

  cmd2 = "blastdbcmd -db #{seq2} -entry #{name2} -range #{from2 + 1}-#{to2} -strand "
  cmd2 << (strand == "+" ? 'plus' : 'minus')
#  puts cmd2

  t2 = File.new("#{i}.seq2", "w")
  IO.popen(cmd2){|io|
    res = io.read
    t2.puts res
  }

  t2.close

  t3 = File.new("run_lagan.#{i}.sh", "w")
  t3.puts "#!/bin/sh"
  t3.puts "export LAGAN_DIR=~/bio/applications/lagan20/"
  t3.puts "export _POSIX2_VERSION=199209"
  t3.puts "SEQ1=#{i}.seq1"
  t3.puts "SEQ2=#{i}.seq2"
  t3.puts "OUTF=#{i}.lagan.out"
  t3.puts "OUTF_MFA=`basename $OUTF .txt`.mfa"
  t3.puts "$LAGAN_DIR/lagan.pl $SEQ1 $SEQ2 -out $OUTF"
  t3.puts "$LAGAN_DIR/lagan.pl $SEQ1 $SEQ2 -out $OUTF_MFA -mfa"
  
  t3.close

#  system "qsub -v PATH run_lagan.#{i}.sh"

end
