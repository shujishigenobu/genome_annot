#!/usr/bin/ruby

$source = "TF_Pfam_DBD.cln.txt"
$pfamdb = "/home/DB/public/processed/Pfam/Pfam-A.hmm"
$outdir = "Results"

pfams = []
File.open($source).each do |l|
  next if /^\#/.match(l)
  a = l.chomp.split(/\t/)
  pfams << a[1]
end
p pfams


pfams.each do |pfam|
  dir = "#{$outdir}/#{pfam}"
  system "mkdir #{dir}"

  hmmfile = "#{pfam}.hmm"
  STDERR.puts pfam
  cmd = "hmmfetch #{$pfamdb} #{pfam} > #{dir}/#{hmmfile}"
  STDERR.puts cmd
  system cmd

  cmd = "./auto_pfam_species.rb #{dir}/#{hmmfile} > #{dir}/#{hmmfile}.summary.txt"
 system cmd


#  cmd = "mv #{hmmfile}* #{dir}"
#  system cmd


end
