qlistf = "Rspe.list"   #query
rlistf = "Znev.list"   #reference
qname= "medium,cat@cats1,cat@cats2"
 
qseqdir = "Rspe"
rseqdir = "Znev"
outdir_base = "lastz_out"
 
qcontigs = File.open(qlistf).readlines.map{|x| x.strip}
rcontigs = File.open(rlistf).readlines.map{|x| x.strip}
 
template = "lastz #{rseqdir}/REF.nib #{qseqdir}/QUERY.nib H=2000 Y=3400 L=6000 K=2200 --format=lav | lavToPsl stdin stdout "

## Template where lastz parameters are optimized for a pair of very similar genomes such as Human-Chimp
# template = "lastz #{rseqdir}/REF.nib #{qseqdir}/QUERY.nib H=0 Y=15000 L=3000 K=4500 E=150 O=600 T=2 --format=lav | lavToPsl stdin stdout " 


p qcontigs.size
p rcontigs.size
 
qcontigs.each do |c1|
  scriptf = "run_lastz_#{c1}.sh"
  #  Dir.mkdir("#{outdir_base}/#{c1}")
  o = File.open(scriptf, "w")
  o.puts "\#\!/bin/sh"
  o.puts "\#\$ -q #{qname}"
  
  rcontigs.each do |c2|
#    p [c1, c2]
    s = template.gsub(/REF/, "#{c2}")
    s = s.gsub(/QUERY/, "#{c1}")
    o.puts s
  end
  o.close
  cmd2 = "qsub -v PATH -cwd -o #{scriptf}.o.psl #{scriptf} "
  puts cmd2
  system cmd2
end
