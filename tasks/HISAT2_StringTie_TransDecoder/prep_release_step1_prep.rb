require 'yaml'
require 'fileutils'

#conff = "OkORF2.conf.yml"
#y = YAML.load(File.open(conff).read

release_prefix = "171215-HsStTd"
project_id = "HorCo01"
transcript_file = "stringtie_merged.transcripts.fasta"
transcript_gtf = "stringtie_merged.gtf"
transcript_gff = "stringtie_merged.gff3"

release_label = "#{release_prefix}-#{project_id}"

Dir.mkdir(release_label)
Dir.mkdir("#{release_label}/ORF_prediction_full")
Dir.mkdir("#{release_label}/ORF_prediction_nonredundant")

FileUtils.cp(transcript_file, "#{release_label}/")
FileUtils.cp(transcript_gtf, "#{release_label}/")
FileUtils.cp(transcript_gff, "#{release_label}/")

%w{ 
stringtie_merged.transcripts.fasta.transdecoder.cds
stringtie_merged.transcripts.fasta.transdecoder.pep
stringtie_merged.transcripts.fasta.transdecoder.gff3
stringtie_merged.transcripts.fasta.transdecoder.bed
stringtie_merged.transcripts.fasta.transdecoder.genome.gff3
}.each do |f|
  FileUtils.cp(f, "#{release_label}/ORF_prediction_full")
end

#m = /^(\w{2,7})(\d{2})$/.match(y['project_id'])
#mnemonic = m[1]
#project_no = m[2]
#typecode= "M"
#cmd = "ruby okorf2/rename_TDrmdup_files.rb #{mnemonic} #{project_no} #{typecode}"
#puts cmd
#system cmd

%w{
ORF_HisatStringtieTD.rmdup.bed
ORF_HisatStringtieTD.rmdup.cds.fa
ORF_HisatStringtieTD.rmdup.pep.fa
ORF_HisatStringtieTD.rmdup.gff3
ORF_HisatStringtieTD.rmdup.genome.gff3
}.each do |f|
  FileUtils.cp(f, "#{release_label}/ORF_prediction_nonredundant")
end
