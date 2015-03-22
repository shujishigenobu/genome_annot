chr = ARGV[0]
left = ARGV[1].to_i
right = ARGV[2].to_i

cfOr_tblastn_data = "../../140829-CRannot/140829-implement_Zhou2012/Cflo_Ors.pep.fa.vs.final.assembly.fasta.blastp.cord_sorted.bed"

cmd = "bedtools intersect -a ../../140829-CRannot/140829-implement_Zhou2012/Cflo_Ors.pep.fa.vs.final.assembly.fasta.blastp.cord_sorted.bed -b stdin | sort -k5,5n"
puts cmd

IO.popen(cmd, "w+") do |io|
  io.puts "#{chr}\t#{left}\t#{right}"
  io.close_write
  puts io.read

end
