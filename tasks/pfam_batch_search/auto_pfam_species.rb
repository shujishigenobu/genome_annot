#!/usr/bin/ruby

require 'bio'

$odb = "/home/DB/public/processed/OrthoDB/OrthoDB7/FASTA_renamed"

DATABASES = {
  'RsGM8' => "/home/shige/Projects/n11723-MiuraG/Data/TermiteG/Releases/Release_140702-RsGM8/RsGM8.pep.fa",
  'Znev' => "/home/shige/Projects/n11723-MiuraG/Data/ZnevGenome/Znev.OGS.v2.2.pep",
  'Bger' => "/home/DB/public/originals/BCM/I5K-pilot/German_cockroach/maker_annotation/version_0.5.3/BGER.faa",
  'Mnat' => "/home/DB/public/GigaDB/100057/Mnat_gene_v1.2.pep.fa",
  'Cpun' => "/home/shige/Projects/n11723-MiuraG/Analysis/140727-RsGM8/141101-Proteinortho/ORF_Cpun140730nr_prefix.pep",
  'Pame' => "/home/shige/Projects/n11723-MiuraG/Analysis/140727-RsGM8/141101-Proteinortho/ORF_Pame140730nr_prefix.pep",
  'Ofor' => "/home/shige/Projects/FungusTermite/Analysis/140417-Ofor_RNAseq/Release_141103-OforRNAseq_denovo/ORF_OdoFor140611.cds.cdest099aS80aL00.pep",
  'Dmel' => "/home/DB/public/processed/OrthoDB/OrthoDB7/FASTA_renamed/DMELA.Drosophila_melanogaster.fas.renamed",
  'Isca' => "/home/DB/public/processed/OrthoDB/OrthoDB7/FASTA_renamed/ISCAP.Ixodes_scapularis.fas.renamed",
  'Tcas' => "/home/DB/public/processed/OrthoDB/OrthoDB7/FASTA_renamed/TCAST.Tribolium_castaneum.fas.renamed",
  'Bmor' => "/home/DB/public/processed/OrthoDB/OrthoDB7/FASTA_renamed/BMORI.Bombyx_mori.fas.renamed",
  "Nvit" => "/home/DB/public/processed/OrthoDB/OrthoDB7/FASTA_renamed/NVITR.Nasonia_vitripennis.fas.renamed",
  "Hsap" => "/home/DB/public/processed/OrthoDB/OrthoDB7/FASTA_renamed/HSAPI.Homo_sapiens.fas.renamed",
  "Apis" => "/home/DB/public/processed/OrthoDB/OrthoDB7/FASTA_renamed/APISU.Acyrthosiphon_pisum.fas.renamed",
  "Phum" => "/home/DB/public/processed/OrthoDB/OrthoDB7/FASTA_renamed/PHUMA.Pediculus_humanus.fas.renamed",
  "Cflo" => "#{$odb}/CFLOR.Camponotus_floridanus.fas.renamed",
  "Agam" => "#{$odb}/AGAMB.Anopheles_gambiae.fas.renamed",
  "Rpro" => "#{$odb}/RPROL.Rhodnius_prolixus.fas.renamed",
#  "Mmus" => "/DB/KEGG/blastdb/m.musculus.pep",
  "Dpul" => "/home/DB/public/processed/OrthoDB/OrthoDB7/FASTA_renamed/DPULE.Daphnia_pulex.fas.renamed",
#  "Scer" =>"/home/DB/public/processed/OrthoDB/OrthoDB7/FASTA_renamed/",
#  "Drer" => "/DB/KEGG/blastdb/d.rerio.pep",
#  "Ggal" => "/DB/KEGG/blastdb/g.gallus.pep",
  "Cele" => "/home/DB/public/processed/OrthoDB/OrthoDB7/FASTA_renamed/CELEG.Caenorhabditis_elegans.fas.renamed",
#  "Atha" => "/DB/KEGG/blastdb/a.thaliana.pep",
#  "Agam" => "/DB/KEGG/blastdb/a.gambiae.pep",
#  "Bmor" => "/DB/SilkDB/blastdb/silkpep.fa",
#  "Ecol" => "/DB/KEGG/blastdb/e.coli.pep",
}

KEY_ORDER = %w{RsGM8 Znev Mnat Ofor Cpun Pame Bger Dmel Agam Phum Rpro Isca Tcas Apis Nvit Cflo Bmor Dpul Cele Hsap}


$evalue_exec = 1.0e-4
$evalue_filter = 1.0e-10
$basedir = "Results"

query_domainf = ARGV[0]
result_files = []

DATABASES.each do |sp, path|

  outf = "#{File.dirname(query_domainf)}/#{File.basename(query_domainf)}.#{sp}.txt"
  outf_tab = outf.sub(/\.txt$/, ".tab.txt")
  outf_domtab = outf.sub(/\.txt$/, ".domtab.txt")
  cmd = "hmmsearch --domtblout #{outf_domtab} --tblout #{outf_tab} -E #{$evalue_exec} #{query_domainf} #{path}"

  STDERR.puts outf
  cmd << " >#{outf}"
  STDERR.puts cmd
  result_files << outf
#  system cmd
end


### generate summary report

hmmtxt = File.open(query_domainf).read
hmmname = /^NAME\s+(\S+)$/.match(hmmtxt)[1]
hmmacc =  /^ACC\s+(\S+)$/.match(hmmtxt)[1]

puts "# HMM_NAME: #{hmmname}"
puts "# HMM_ACC:  #{hmmacc}"
puts "#"
puts "# " + %w{species hmm #genes #domains  hits}.join("\t")

sp2resultf = {}
result_files.each do |f|
  sp = /\.hmm\.(.+)\.txt/.match(f)[1]
  sp2resultf[sp] = f
end

KEY_ORDER.each do |k|
  f = sp2resultf[k]
  m = /\.hmm\.(.+)\.txt/.match(f)
  sp = m[1]
  motif = m.pre_match
#  p [sp, motif]
#  path = "#{$basedir}/#{motif}/#{f}"
  path = f
#  rep = Bio::HMMER::Report.new(File.read(path))

  tabf = path.sub(/\.txt$/, ".tab.txt")
  domtabf = path.sub(/\.txt$/, ".domtab.txt")
# p [tabf, domtabf]

  count_hits = 0
  count_domhits = 0
  hit_names = []
  File.open(tabf).each do |l|
    next if /^\#/.match(l)
    count_hits += 1
    hit_names << l.chomp.split(/\s+/)[0]
  end
  File.open(domtabf).each do |l|
    next if /^\#/.match(l)
    count_domhits += 1
  end

#  puts "# Species: #{sp} | Motif: #{motif}"
  puts [sp, File.basename(motif), count_hits, count_domhits, hit_names.join(",")].join("\t")
#  passed.each do |h|
#    puts [h.accession, h.evalue].join("\t")
#  end
end
#puts "//"

exit

## Retrieve sequences
result_files.each do |f|
  passed = []
  m = /\.hmm\.(.+)\.txt/.match(f)
  sp = m[1]
  motif = m.pre_match
  dbpath = DATABASES[sp]
#  p f
  Bio::FlatFile.open(Bio::HMMER::Report, f).each do |rep|

    rep.hits.each do |h|
      if h.evalue < $evalue_filter
        passed << h
      end
    end
  
    fastacmd = Bio::Blast::Fastacmd.new(dbpath)
    outf = "#{File.basename(query_domainf)}.#{sp}.pep.fas"
    o = File.open(outf, "w")
    passed.each do |h|
      o.puts fastacmd.get_by_id(h.accession)
    end
    o.close
  end
end
